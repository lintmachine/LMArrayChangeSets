#
# Be sure to run `pod lib lint LMArrayChangeSets.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "LMArrayChangeSets"
  s.version          = "0.1.1"
  s.summary          = "Categories to help in updating array-backed UITableViews and UICollectionViews with row/cell animations."
  s.description      = <<-DESC
This is a set of simple categories that help with a common pattern I use for updating array-backed UITableViews and UICollectionViews.

It extends NSArray to provide a simple diff functionality. You provide the initial array, the updated array, and an identity comparison block, and the method returns an NSDictionary of NSIndexSets with the inserted, deleted and moved indexes.

Categories are provided for UITableView and UICollectionView that can take the IndexSet dictionary and perform the updates as a batch with row/cell animation.

                       DESC
  s.homepage         = "https://github.com/lintmachine/LMArrayChangeSets"
  s.license          = 'MIT'
  s.author           = { "cdann" => "cdann@lintmachine.com" }
  s.source           = { :git => "https://github.com/lintmachine/LMArrayChangeSets.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/lintmachine'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'LMArrayChangeSets' => ['Pod/Assets/*.png']
  }

end
