class VisitedSitesController < UITableViewController
  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor
    self.title = "Visits"
  end

  def initWithNibName(name, bundle: bundle)
    super
    @defaults = NSUserDefaults.standardUserDefaults
    @user_id = @defaults['twitter_id']
    @user = User.new
    @user.visited_sites(@user_id) do |visits|
      @location_names = visits.values
      @visits = visits
    end

    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemHistory, tag: 3)
    self
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier)
      cell = UITableViewCell.alloc.initWithStyle(
        UITableViewCellStyleDefault,
        reuseIdentifier:@reuseIdentifier)

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator

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

    systems_controller = SystemsController.alloc.initWithParams({location_id: location_id})
    self.navigationController.pushViewController(systems_controller, animated:true)
  end
end
