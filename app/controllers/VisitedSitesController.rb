class VisitedSitesController < UIViewController
  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor
    @label = UILabel.alloc.initWithFrame(CGRectZero)
    self.title = "Visited Sites"
    @label.text = "Where you've visited"
    @label.sizeToFit
    @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    self.view.addSubview(@table)
    @table.dataSource = self
    @table.delegate = self
    @data = ("A".."Z").to_a
  end

  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemHistory, tag: 3)
    self
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(
        UITableViewCellStyleDefault,
        reuseIdentifier:@reuseIdentifier)
    end

    cell.textLabel.text = @data[indexPath.row]

    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @data.count
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    letter = sections[indexPath.section]

    systems_controller = SystemsController.alloc.initWithNibName(nil, bundle: nil)
    self.navigationController.pushViewController(systems_controller, animated:true)
  end

  def sections
    @data.sort
  end
end
