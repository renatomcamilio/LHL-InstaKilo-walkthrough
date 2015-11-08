//
//  ViewController.m
//  InstaKilo
//
//  Created by Renato Camilio on 2015-11-07.
//  Copyright © 2015 Renato Camilio. All rights reserved.
//

#import "PhotosCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "PhotoGroupHeaderCollectionReusableView.h"
#import "Photo.h"

@interface PhotosCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *photoList;
// list of Photos object to populate photoCollectionView

@property (nonatomic, strong) NSMutableOrderedSet *photoLocations;
@property (nonatomic, strong) NSMutableOrderedSet *photoSubjects;
// both photoLocations and photoSubjects are mutable Sets that store unique locations and
// subjects respectively, and will be useful for grouping information together later on

@property (nonatomic, weak) IBOutlet UISegmentedControl *photoGroupTypeSegmentedControl;
// this segmented control is the user interface to change the photoCollectionView grouping

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;

@end

@implementation PhotosCollectionViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    _photoLocations = [NSMutableOrderedSet orderedSet];
    _photoSubjects = [NSMutableOrderedSet orderedSet];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Photo *image1 = [[Photo alloc] initWithImage:[UIImage imageNamed:@"tuscany.jpg"] location:@"montreal" subject:@"travel"];
    Photo *image2 = [[Photo alloc] initWithImage:[UIImage imageNamed:@"vienna.jpg"] location:@"home" subject:@"holiday"];
    Photo *image3 = [[Photo alloc] initWithImage:[UIImage imageNamed:@"prague.jpg"] location:@"vancouver" subject:@"travel"];
    Photo *image4 = [[Photo alloc] initWithImage:[UIImage imageNamed:@"arch.jpg"] location:@"world" subject:@"weekend"];
    Photo *image5 = [[Photo alloc] initWithImage:[UIImage imageNamed:@"bridge.jpg"] location:@"toronto" subject:@"weekend"];
    Photo *image6 = [[Photo alloc] initWithImage:[UIImage imageNamed:@"halloween.jpg"] location:@"home" subject:@"holiday"];
    Photo *image7 = [[Photo alloc] initWithImage:[UIImage imageNamed:@"condo.jpg"] location:@"home" subject:@"interests"];
    Photo *image8 = [[Photo alloc] initWithImage:[UIImage imageNamed:@"autumn.jpg"] location:@"vancouver" subject:@"interests"];
    Photo *image9 = [[Photo alloc] initWithImage:[UIImage imageNamed:@"bcplace.jpg"] location:@"world" subject:@"travel"];
    Photo *image10 = [[Photo alloc] initWithImage:[UIImage imageNamed:@"luxuryhome.jpg"] location:@"vancouver" subject:@"interests"];
  
    // populate photoList with initial data
    self.photoList = [NSMutableArray arrayWithArray:@[image1, image2, image3, image4, image5, image6, image7, image8, image9, image10]];
    
    // initial update of subjects and locations (essentially extracting unique locations and subjects)
    [self updatePhotoLocations];
    [self updatePhotoSubjects];
}

#pragma mark - Group Type Segmented Control

- (IBAction)photoGroupTypeChanged:(id)sender {
    // based on `PhotoGroupType` enum we can use `switch` statements to find out
    // which option is selected on the `photoGroupTypeSegmentedControl`
    switch (self.photoGroupTypeSegmentedControl.selectedSegmentIndex) {
        case PhotoGroupTypeLocation:
            [self updatePhotoLocations];
            break;
        case PhotoGroupTypeSubject:
            [self updatePhotoSubjects];
            break;
        default:
            NSLog(@"Should never be reached");
            break;
    }
    
    [self.photoCollectionView reloadData];
}

#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger numberOfSections;
    
    switch (self.photoGroupTypeSegmentedControl.selectedSegmentIndex) {
        case PhotoGroupTypeLocation:
            numberOfSections = [self.photoLocations count];
            break;
        case PhotoGroupTypeSubject:
            numberOfSections = [self.photoSubjects count];
            break;
        default:
            NSLog(@"Should never be reached");
            break;
    }
    
    return numberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfItems;
    
    switch (self.photoGroupTypeSegmentedControl.selectedSegmentIndex) {
        case PhotoGroupTypeLocation:
            numberOfItems = [[[self photoListGroupedByLocation] objectForKey:self.photoLocations[section]] count];
            break;
        case PhotoGroupTypeSubject:
            numberOfItems = [[[self photoListGroupedBySubject] objectForKey:self.photoSubjects[section]] count];
            break;
        default:
            NSLog(@"Should never be reached");
            break;
    }
    
    return numberOfItems;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        // IMPORTANT: you might have trouble using the UICollectionReusableView directly,
        // it's recommended you subclass it and use it instead of the UICollectionReusableView
        // itself.
        // Docs from Apple:
            // OverviewSubclassing Notes (UICollectionReusableView)
            // This class is intended to be subclassed. Most methods defined by this class have minimal or no implementations. You are not required to override any of the methods but can do so in cases where you want to respond to changes in the view’s usage or layout.
        PhotoGroupHeaderCollectionReusableView *collectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([PhotoGroupHeaderCollectionReusableView class]) forIndexPath:indexPath];
        
        switch (self.photoGroupTypeSegmentedControl.selectedSegmentIndex) {
            case PhotoGroupTypeLocation:
                collectionReusableView.titleLabel.text = [self.photoLocations objectAtIndex:indexPath.section];
                break;
            case PhotoGroupTypeSubject:
                collectionReusableView.titleLabel.text = [self.photoSubjects objectAtIndex:indexPath.section];
                break;
            default:
                NSLog(@"Should never be reached");
                break;
        }
        
        return collectionReusableView;
    }
    
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PhotoCollectionViewCell class]) forIndexPath:indexPath];

    switch (self.photoGroupTypeSegmentedControl.selectedSegmentIndex) {
        case PhotoGroupTypeLocation:
            cell.imageView.image = ((Photo *)[[[self photoListGroupedByLocation] objectForKey:[self.photoLocations objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]).image;
            break;
        case PhotoGroupTypeSubject:
            cell.imageView.image = ((Photo *)[[[self photoListGroupedBySubject] objectForKey:[self.photoSubjects objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]).image;
            break;
        default:
            NSLog(@"Should never be reached");
            break;
    }
    
    return cell;
}

#pragma mark - Photo Locations

// extract all the unique photo locations and assign to `photoLocations` property
// the data structure is pretty much like an Array of locations*:
// @[@"vancouver", @"toronto", @"montreal"...]
// *Note: it's actually a NSMutableOrderedSet, which is like an array of unique values
- (void)updatePhotoLocations {
    for (Photo *photo in self.photoList) {
        // we would check if `self.photoLocations` contain `photo.location`, and,
        // if not, add object `photo.location` to `self.photoLocations`
        // (but since we are using NSMudatableOrderedSet, which is a Set Subclass,
        // it eliminates duplicates for us)
        [self.photoLocations addObject:photo.location];
    }
}

// group photos by location
// the data structure will be a Dictionary with Arrays of Photo Objects:
// @{ @"vancouver": @[image1, image2], @"toronto": @[image3, image5], @"montreal": @[image4] }
- (NSDictionary *)photoListGroupedByLocation {
    NSMutableDictionary *groupedPhotos = [NSMutableDictionary dictionary];
    
    for (Photo *photo in self.photoList) {
        BOOL doesHaveLocationGroup = [groupedPhotos[photo.location] isKindOfClass:[NSArray class]];
        
        if (doesHaveLocationGroup) {
            groupedPhotos[photo.location] = [groupedPhotos[photo.location] arrayByAddingObject:photo];
        } else {
            groupedPhotos[photo.location] = @[photo];
        }
    }
    
    return groupedPhotos;
}

#pragma mark - Photo Subjects

// extract all the unique photo subjects and assign to `photoSubjects` property
// the data structure is pretty much like an Array of subjects*:
// @[@"holiday", @"weekend", @"interests"...]
// *Note: it's actually a NSMutableOrderedSet, which is like an array of unique values
- (void)updatePhotoSubjects {
    for (Photo *photo in self.photoList) {
        // we would check if `self.photoSubjects` contain `photo.subject`, and,
        // if not, add object `photo.subject` to `self.photoSubjects`
        // (but since we are using NSMudatableOrderedSet, which is a Set Subclass,
        // it eliminates duplicates for us)
        [self.photoSubjects addObject:photo.subject];
    }
}

// group photos by subject
// the data structure will be a Dictionary with Arrays of Photo Objects:
// @{ @"interests": @[image1, image2], @"holiday": @[image3, image5], @"weekend": @[image4] }
- (NSDictionary *)photoListGroupedBySubject {
    NSMutableDictionary *groupedPhotos = [NSMutableDictionary dictionary];
    
    for (Photo *photo in self.photoList) {
        BOOL doesHaveSubjectGroup = [groupedPhotos[photo.subject] isKindOfClass:[NSArray class]];
        
        if (doesHaveSubjectGroup) {
            groupedPhotos[photo.subject] = [groupedPhotos[photo.subject] arrayByAddingObject:photo];
        } else {
            groupedPhotos[photo.subject] = @[photo];
        }
    }
    
    return groupedPhotos;
}

@end
