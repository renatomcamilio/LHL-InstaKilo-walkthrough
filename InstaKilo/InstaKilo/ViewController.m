//
//  ViewController.m
//  InstaKilo
//
//  Created by Benson Huynh on 2015-11-04.
//  Copyright © 2015 Benson Huynh. All rights reserved.
//

#import "ViewController.h"
#import "MyCollectionViewCell.h"
#import "Photo.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic, strong) NSMutableArray *photoList;
@property (nonatomic, assign) PhotoFilterType photoFilterType;
@property (nonatomic, strong) NSMutableOrderedSet *photoLocations;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Photo *image1 = [[Photo alloc] initWithImage:[UIImage imageNamed:@"tuscany.jpg"] location:@"worldPicture" subject:@"travel"];
    Photo *image2 = [[Photo alloc] initWithImage:[UIImage imageNamed:@"vienna.jpg"] location:@"worldPicture" subject:@"travel"];
    Photo *image3 = [[Photo alloc] initWithImage:[UIImage imageNamed:@"prague.jpg"] location:@"worldPicture" subject:@"travel"];
    Photo *image4 = [[Photo alloc] initWithImage:[UIImage imageNamed:@"arch.jpg"] location:@"worldPicture" subject:@"travel"];
    Photo *image5 = [[Photo alloc] initWithImage:[UIImage imageNamed:@"bridge.jpg"] location:@"downtown Vancouver" subject:@"weekend"];
    Photo *image6 = [[Photo alloc] initWithImage:[UIImage imageNamed:@"halloween.jpg"] location:@"home" subject:@"holiday"];
    Photo *image7 = [[Photo alloc] initWithImage:[UIImage imageNamed:@"condo.jpg"] location:@"home" subject:@"interests"];
    Photo *image8 = [[Photo alloc] initWithImage:[UIImage imageNamed:@"autumn.jpg"] location:@"vancouver" subject:@"interests"];
    Photo *image9 = [[Photo alloc] initWithImage:[UIImage imageNamed:@"bcplace.jpg"] location:@"worldPicture" subject:@"travel"];
    Photo *image10 = [[Photo alloc] initWithImage:[UIImage imageNamed:@"luxuryhome.jpg"] location:@"vancouver" subject:@"interests"];
  
    self.photoList = [NSMutableArray arrayWithArray:@[image1, image2, image3, image4, image5, image6, image7, image8, image9, image10]];
    
    self.photoLocations = [NSMutableOrderedSet orderedSet];
                                                 
    
    // updates locations
    [self updatePhotoLocations];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *location = [self.photoLocations objectAtIndex:indexPath.section];
    Photo *photo = [[[self photoListGroupedByLocation] objectForKey:location] objectAtIndex:indexPath.row];
    cell.photoImageCell.image = photo.image;
    
    return cell;
}


- (IBAction)filterSelector:(id)sender {
    
    UISegmentedControl *segmentButtons = (UISegmentedControl *)sender;

    switch (segmentButtons.selectedSegmentIndex) {
        case PhotoFilterTypeLocation:
            // return the photo sorted by location
            break;
        case PhotoFilterTypeSubject:
            // return the photo sorted by subject
            break;
        default:
            NSLog(@"Should never be reached");
            break;
    }
    
    [self.photoCollectionView.collectionViewLayout invalidateLayout];
}


//determine the section based on subjects and location
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.photoLocations count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *collectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"sectionTitle" forIndexPath:indexPath];
    
    
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:collectionReusableView.frame];
        NSString *location = [self.photoLocations objectAtIndex:indexPath.section];
        titleLabel.text = location;
        
        [collectionReusableView addSubview:titleLabel];
    }
    
    return collectionReusableView;
}

//determine the items in the section

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSString *location = self.photoLocations[section];
    NSArray *locationPhotos = [[self photoListGroupedByLocation] objectForKey:location];
    
    return [locationPhotos count];
}

// photo locations

- (void)updatePhotoLocations {
    // filter photolist items based on the selected photoFilterType
    for (Photo *photo in self.photoList) {
        // does `locations` have `photo.location`?
        // if not, include `photo.location` into `locations` list
        // other than, ignore
        
        // ^ (since we are using SETs, it eliminates duplicates for us)
        [self.photoLocations addObject:photo.location];
    }
}

- (NSDictionary *)photoListGroupedByLocation {
    
    NSMutableDictionary *groupedPhotos = [NSMutableDictionary dictionary];
    
    for (Photo *photo in self.photoList) {
        BOOL doesHaveLocationPhotos = [groupedPhotos[photo.location] isKindOfClass:[NSArray class]];
        
        if (doesHaveLocationPhotos) {
            groupedPhotos[photo.location] = [groupedPhotos[photo.location] arrayByAddingObject:photo];
        } else {
            groupedPhotos[photo.location] = @[photo];
        }
    }
    
    NSLog(@"%@", groupedPhotos);
    
    return groupedPhotos;
}

@end
