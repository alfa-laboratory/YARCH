import UIKit

class CatalogView: UIView {
    var tableView: UITableView

    lazy var emptyView = CatalogEmptyView()

    lazy var errorView: CatalogErrorView = {
        let view = CatalogErrorView()
        view.delegate = self.refreshActionsDelegate
        return view
    }()

    weak var refreshActionsDelegate: CatalogErrorViewDelegate?

    init(frame: CGRect = CGRect.zero,
         loadingDataSource: UITableViewDataSource,
         loadingDelegate: UITableViewDelegate,
         refreshDelegate: CatalogErrorViewDelegate) {
        tableView = UITableView(delegate: loadingDelegate, dataSource: loadingDataSource)
        super.init(frame: frame)
        refreshActionsDelegate = refreshDelegate
        configureTableView()
        addSubviews()
        makeConstraints()

        emptyView.isHidden = true
        tableView.isHidden = true
        errorView.isHidden = true
    }

    func configureTableView() {
        #if os(iOS)
        tableView.separatorStyle = .none
        #endif
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviews() {
        addSubview(tableView)
        addSubview(emptyView)
        addSubview(errorView)
    }

    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func showEmptyView(title: String, subtitle: String) {
        show(view: emptyView)
        emptyView.title.text = title
        emptyView.subtitle.text = subtitle
    }

    func showLoading() {
        show(view: tableView)
    }

    func showError(message: String) {
        show(view: errorView)
        errorView.title.text = message
    }

    func showTable() {
        show(view: tableView)
    }

    func show(view: UIView) {
        subviews.forEach { $0.isHidden = (view != $0) }
    }

    func updateTableViewData(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        showTable()
        tableView.tableFooterView = nil
        tableView.tableHeaderView = nil
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        tableView.reloadData()
    }
}
