//
//  ChatViewController.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 01/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReusableKit
import RxDataSources

final class ChatViewController: BaseViewController {

  // MARK: Constants

  fileprivate struct Metric {
    static let messageSectionInsetTop = 10.f
    static let messageSectionInsetBottom = 10.f
    static let messageSectionInsetLeftRight = 10.f
    static let messageSectionItemSpacing = 10.f
  }

  fileprivate struct Reusable {
    static let incomingMessageCell = ReusableCell<IncomingMessageCell>()
    static let outgoingMessageCell = ReusableCell<OutgoingMessageCell>()
  }


  // MARK: Properties

  fileprivate let dataSource = RxCollectionViewSectionedReloadDataSource<ChatViewSection>()


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


  // MARK: Initializing

  init(viewModel: ChatViewModelType) {
    super.init()
    self.configure(viewModel: viewModel)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white

    self.view.addSubview(self.collectionView)
  }

  override func setupConstraints() {
    self.collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }


  // MARK: Configuring

  private func configure(viewModel: ChatViewModelType) {
    // Delegate
    self.collectionView.rx
      .setDelegate(self)
      .addDisposableTo(self.disposeBag)

    // DataSource
    self.dataSource.configureCell = { dataSource, collectionView, indexPath, sectionItem in
      switch sectionItem {
      case let .incomingMessage(cellModel):
        let cell = collectionView.dequeue(Reusable.incomingMessageCell, for: indexPath)
        cell.configure(viewModel: cellModel)
        return cell

      case let .outgoingMessage(cellModel):
        let cell = collectionView.dequeue(Reusable.outgoingMessageCell, for: indexPath)
        cell.configure(viewModel: cellModel)
        return cell
      }
    }

    // Input
    self.rx.viewDidLoad
      .bindTo(viewModel.viewDidLoad)
      .addDisposableTo(self.disposeBag)

    // Output
    viewModel.sections
      .drive(self.collectionView.rx.items(dataSource: self.dataSource))
      .addDisposableTo(self.disposeBag)
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
    let cellModel = self.dataSource[indexPath]
    switch cellModel {
    case let .incomingMessage(cellModel):
      return IncomingMessageCell.size(thatFitsWidth: cellWidth, viewModel: cellModel)

    case let .outgoingMessage(cellModel):
      return OutgoingMessageCell.size(thatFitsWidth: cellWidth, viewModel: cellModel)
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
