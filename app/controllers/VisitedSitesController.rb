class VisitedSitesController < UIViewController
  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor
    @label = UILabel.alloc.initWithFrame(CGRectZero)
    self.title = "Visited Sites"
    @label.text = "Where you've visited"
    @label.sizeToFit
    @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
    @user = User.new
    user_id = 1
    @user.visited_sites(user_id) do |visits|
      @location_names = visits.values
      @visits = visits
      @table = UITableView.alloc.initWithFrame(self.view.bounds)
      self.view.addSubview(@table)
      @table.dataSource = self
      @table.delegate = self
    end
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

    cell.textLabel.text = @location_names[indexPath.row]

    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @location_names.count
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    location_name = @location_names[indexPath.row]
    location = @visits.select{ |key, value| value == location_name }
    location_id = location.keys.first.to_i

    systems_controller = SystemsController.alloc.initWithParams({system_id: location_id})
    self.navigationController.pushViewController(systems_controller, animated:true)
  end
end
