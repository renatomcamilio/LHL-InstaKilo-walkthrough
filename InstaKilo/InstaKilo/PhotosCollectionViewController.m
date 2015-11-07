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
@property (nonatomic, assign) PhotoGroupType photoGroupType;
@property (nonatomic, strong) NSMutableOrderedSet *photoLocations;
@property (nonatomic, strong) NSMutableOrderedSet *photoSubjects;
@property (nonatomic, weak) IBOutlet UISegmentedControl *photoGroupTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;

@end

@implementation PhotosCollectionViewController


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
  
    self.photoList = [NSMutableArray arrayWithArray:@[image1, image2, image3, image4, image5, image6, image7, image8, image9, image10]];
    
    self.photoLocations = [NSMutableOrderedSet orderedSet];
    self.photoSubjects = [NSMutableOrderedSet orderedSet];
    
    // updates locations
    [self updatePhotoLocations];
    [self updatePhotoSubjects];
}

- (IBAction)photoGroupTypeChanged:(id)sender {
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

- (void)updatePhotoLocations {
    // extract all the unique photo locations
    for (Photo *photo in self.photoList) {
        // does `self.photoLocations` contain `photo.location`?
        // if not, add object `photo.location` to `self.photoLocations` list
        // other than that, ignore
        
        // Note: ^ (since we are using NSMudatableOrderedSet, which is a Set Subclass,
        // it eliminates duplicates for us)
        [self.photoLocations addObject:photo.location];
    }
}

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

- (void)updatePhotoSubjects {
    // extract all the unique photo subjects
    for (Photo *photo in self.photoList) {
        // does `self.photoSubjects` contain `photo.subject`?
        // if not, add object `photo.subject` to `self.photoSubjects` list
        // other than that, ignore
        
        // Note: ^ (since we are using NSMudatableOrderedSet, which is a Set Subclass,
        // it eliminates duplicates for us)
        [self.photoSubjects addObject:photo.subject];
    }
}

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
