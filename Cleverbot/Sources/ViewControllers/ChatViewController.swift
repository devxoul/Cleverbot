//
//  ChatViewController.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 01/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit
import ReusableKit
import RxDataSources
import RxKeyboard
import RxSwift

final class ChatViewController: BaseViewController, View {
  typealias Reactor = ChatViewReactor

  // MARK: Constants

  fileprivate struct Metric {
    static let messageSectionInsetTop = 10.f
    static let messageSectionInsetBottom = 10.f
    static let messageSectionInsetLeftRight = 10.f
    static let messageSectionItemSpacing = 10.f
  }

  private enum Font {
    static let placeholderLabel = UIFont.boldSystemFont(ofSize: 18)
  }

  private enum Color {
    static let placeholderLabelText = 0xCCCCCC.color
  }

  fileprivate struct Reusable {
    static let incomingMessageCell = ReusableCell<IncomingMessageCell>()
    static let outgoingMessageCell = ReusableCell<OutgoingMessageCell>()
  }


  // MARK: Properties

  private lazy var dataSource = self.createDataSource()


  // MARK: UI

  fileprivate let collectionView = UICollectionView(
    frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.alwaysBounceVertical = true
    $0.keyboardDismissMode = .interactive
    $0.register(Reusable.incomingMessageCell)
    $0.register(Reusable.outgoingMessageCell)
  }
  fileprivate let messageInputBar = MessageInputBar()
  private let placeholderLabel: UILabel = UILabel().then {
    $0.font = Font.placeholderLabel
    $0.text = "Say hi 👋"
    $0.textColor = Color.placeholderLabelText
    $0.isUserInteractionEnabled = false
  }


  // MARK: Initializing

  init(reactor: Reactor) {
    super.init()
    self.title = "Cleverbot 🤖"
    self.reactor = reactor
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<ChatViewSection> {
    return .init(
      configureCell: { dataSource, collectionView, indexPath, sectionItem in
        switch sectionItem {
        case let .incomingMessage(reactor):
          let cell = collectionView.dequeue(Reusable.incomingMessageCell, for: indexPath)
          cell.reactor = reactor
          return cell

        case let .outgoingMessage(reactor):
          let cell = collectionView.dequeue(Reusable.outgoingMessageCell, for: indexPath)
          cell.reactor = reactor
          return cell
        }
      }
    )
  }


  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white

    self.collectionView.contentInset.bottom = self.messageInputBar.intrinsicContentSize.height
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset

    self.view.addSubview(self.collectionView)
    self.view.addSubview(self.placeholderLabel)
    self.view.addSubview(self.messageInputBar)
  }

  override func setupConstraints() {
    self.collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    self.placeholderLabel.snp.makeConstraints { make in
      make.center.equalTo(self.collectionView)
    }
    self.messageInputBar.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
    }
  }


  // MARK: Configuring

  func bind(reactor: Reactor) {
    // Delegate
    self.collectionView.rx
      .setDelegate(self)
      .disposed(by: self.disposeBag)

    // Action
    self.messageInputBar.rx.sendButtonTap.map(Reactor.Action.send)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // State
    reactor.state.map { $0.sections }
      .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    // UI
    let wasReachedBottom: Observable<Bool> = self.collectionView.rx.contentOffset
      .map { [weak self] _ in
        self?.collectionView.isReachedBottom() ?? false
      }

    reactor.state.map { $0.sections }
      .debounce(0.1, scheduler: MainScheduler.instance)
      .withLatestFrom(wasReachedBottom) { ($0, $1) }
      .filter { _, wasReachedBottom in wasReachedBottom == true }
      .subscribe(onNext: { [weak self] _ in
        // scroll to bottom when receive message only if last content offset was at the bottom
        self?.collectionView.scrollToBottom(animated: true)
      })
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.sections.first?.items.isEmpty != true }
      .bind(to: self.placeholderLabel.rx.isHidden)
      .disposed(by: self.disposeBag)

    // Keyboard
    RxKeyboard.instance.visibleHeight
      .drive(onNext: { [weak self] keyboardVisibleHeight in
        guard let `self` = self, self.didSetupConstraints else { return }
        self.messageInputBar.snp.updateConstraints { make in
          var offset: CGFloat = -keyboardVisibleHeight
          if keyboardVisibleHeight > 0 {
            offset += self.view.safeAreaInsets.bottom
          }
          make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(offset)
        }
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0) {
          self.collectionView.contentInset.bottom = keyboardVisibleHeight + self.messageInputBar.height
          self.collectionView.scrollIndicatorInsets.bottom = self.collectionView.contentInset.bottom
          self.view.layoutIfNeeded()
        }
      })
      .disposed(by: self.disposeBag)

    RxKeyboard.instance.willShowVisibleHeight
      .drive(onNext: { [weak self] keyboardVisibleHeight in
        self?.collectionView.scrollToBottom(animated: true)
      })
      .disposed(by: self.disposeBag)
  }

}


// MARK: - UICollectionViewDelegateFlowLayout

extension ChatViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let cellWidth = collectionView.cellWidth(forSectionAt: indexPath.section)
    let reactor = self.dataSource[indexPath]
    switch reactor {
    case let .incomingMessage(reactor):
      return IncomingMessageCell.size(thatFitsWidth: cellWidth, reactor: reactor)

    case let .outgoingMessage(reactor):
      return OutgoingMessageCell.size(thatFitsWidth: cellWidth, reactor: reactor)
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(
      top: Metric.messageSectionInsetTop,
      left: Metric.messageSectionInsetLeftRight,
      bottom: Metric.messageSectionInsetBottom,
      right: Metric.messageSectionInsetLeftRight
    )
  }

}
