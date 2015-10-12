//
//  DKImageBrowser.m
//
//  Created by dkhamsing on 3/20/14.
//
//

// Controllers
#import "DKImageBrowser.h"

// Views
#import "DKImageCell.h"


@interface DKImageBrowser () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    
    /** Enum for strip position. */
    NS_ENUM(NSInteger, DKThumbnailStripPositions) {
        DKThumbnailStripPositionTop,
        DKThumbnailStripPositionBottom,
    };
}

@property (nonatomic,strong) UICollectionView *DKImageCollectionView;

@property (nonatomic,strong) UICollectionView *DKThumbnailCollectionView;

@property (nonatomic,strong) UIView *mainContainer;

@property (nonatomic) NSInteger currentPage;

@end


@implementation DKImageBrowser

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.DKImageWidth = self.view.bounds.size.width - 100;
        self.DKImagePadding = 20;
        self.DKThumbnailStripHeight = 100;
        self.DKBackgroundColor = [UIColor whiteColor];
        self.DKThumbnailStripPosition = DKThumbnailStripPositionBottom;
        
        self.currentPage = 0;
        self.view.backgroundColor = self.DKBackgroundColor;
    }
    return self;
}


- (void)setDKBackgroundColor:(UIColor *)DKBackgroundColor {
    _DKBackgroundColor = DKBackgroundColor;
    self.view.backgroundColor = self.DKBackgroundColor;
}


#pragma mark - View Cycle

NSString *const DKBottomCellIdentifer = @"DKBottomCellIdentifer";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect frame;
    frame = self.view.bounds;
    
    // Image collection view
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = self.DKImagePadding;
    
    //TODO: account for nav bar
    
    frame.origin = CGPointMake(0, self.DKImagePadding + 100);
    frame.size.width = self.view.frame.size.width;
    frame.size.height = self.view.frame.size.width/1.7777777;
    _DKImageCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    _DKImageCollectionView.showsHorizontalScrollIndicator = NO;
    _DKImageCollectionView.delegate = self;
    _DKImageCollectionView.dataSource = self;
    _DKImageCollectionView.backgroundColor = [UIColor whiteColor];
    _DKImageCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    [_DKImageCollectionView registerClass:[DKImageCell class] forCellWithReuseIdentifier:DKBottomCellIdentifer];
    [self.view addSubview:_DKImageCollectionView];
    
    // Thumbnail collection view
    UICollectionViewFlowLayout *bottomLayout = [[UICollectionViewFlowLayout alloc] init];
    bottomLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    bottomLayout.minimumInteritemSpacing = 0;
    bottomLayout.minimumLineSpacing = self.DKImagePadding;
    
    frame.origin = CGPointMake(0 , _DKImageCollectionView.frame.size.height + _DKImageCollectionView.frame.origin.y + self.DKImagePadding);
    frame.size.width =  self.view.frame.size.width;
    frame.size.height = self.DKThumbnailStripHeight-self.DKImagePadding;
    _DKThumbnailCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:bottomLayout];
    _DKThumbnailCollectionView.showsHorizontalScrollIndicator = NO;
    _DKThumbnailCollectionView.allowsMultipleSelection = YES;
    _DKThumbnailCollectionView.delegate = self;
    _DKThumbnailCollectionView.dataSource = self;
    _DKThumbnailCollectionView.backgroundColor = self.DKBackgroundColor;
    [_DKThumbnailCollectionView registerClass:[DKImageCell class] forCellWithReuseIdentifier:DKBottomCellIdentifer];
    [self.view addSubview:_DKThumbnailCollectionView];
    
    // Reposition
    switch (_DKThumbnailStripPosition) {
        case DKThumbnailStripPositionTop: {
            
            CGRect frame = _DKThumbnailCollectionView.frame;
            frame.origin.y = 32+ self.DKImagePadding *2;
            _DKThumbnailCollectionView.frame = frame;
            
            frame = _DKImageCollectionView.frame;
            frame.origin.y = _DKThumbnailCollectionView.frame.size.height + _DKThumbnailCollectionView.frame.origin.y - self.DKImagePadding;
            _DKImageCollectionView.frame = frame;
        }
            break;
            
        default:
            NSLog(@"TODO: strip position for %@", @(_DKThumbnailStripPosition));
            break;
    }
    
    
    // load collection views
    [_DKImageCollectionView reloadData];
    [_DKThumbnailCollectionView reloadData];
    
    if (_DKStartIndex>0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_DKStartIndex inSection:0];
        [_DKThumbnailCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        [_DKImageCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
    
    // Add button
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 10, self.view.frame.size.width-40, 35)];
    [button setTitle:@"Selecciona una imagen" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setBackgroundColor:[UIColor primaryColor]];
    [button addTarget:self action:@selector(pickImage:) forControlEvents:UIControlEventTouchUpInside];
    [button.layer setCornerRadius:2.0f];
    [button.layer setMasksToBounds:YES];
    [self.view addSubview:button];
    
    // View tutorial button
    button = [[UIButton alloc]initWithFrame:CGRectMake(20, button.frame.size.height+20, (self.view.frame.size.width-50)/2, 35)];
    [button setImage:[UIImage imageNamed:@"favored"] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor infoColor]];
    [button setTitleColor:[UIColor primaryColor] forState:UIControlStateNormal];
    //[button addTarget:self action:@selector(howTo:) forControlEvents:UIControlEventTouchUpInside];
    [button.layer setCornerRadius:2.0f];
    [button.layer setMasksToBounds:YES];
    [self.view addSubview:button];
    
    // View tutorial button
    button = [[UIButton alloc]initWithFrame:CGRectMake(button.frame.size.width+30, button.frame.size.height+20, (self.view.frame.size.width-50)/2, 35)];
    [button setTitle:@"Siguiente >" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setBackgroundColor:[UIColor successColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[button addTarget:self action:@selector(howTo:) forControlEvents:UIControlEventTouchUpInside];
    [button.layer setCornerRadius:2.0f];
    [button.layer setMasksToBounds:YES];
    [self.view addSubview:button];
}


#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {    
    return _DKImageDataSource.count;
}


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath; {
    return YES;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cview cellForItemAtIndexPath:(NSIndexPath *)indexPath {    
    if ((cview==_DKImageCollectionView) &&
        (indexPath.item>1)) {
        [_DKThumbnailCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
    DKImageCell *cell = [cview dequeueReusableCellWithReuseIdentifier:DKBottomCellIdentifer forIndexPath:indexPath];
    
    NSObject *obj = _DKImageDataSource[indexPath.row];
    if ([obj isKindOfClass:[UIImage class]]) {
        UIImage *image = _DKImageDataSource[indexPath.row];
        cell.DKImageView.image = image;
        [cell.DKImageView setFrame:CGRectMake(cell.DKImageView.frame.origin.x, cell.DKImageView.frame.origin.y, cell.DKImageView.frame.size.width, cell.DKImageView.frame.size.width/1.7777777)];
    }
    else if ([obj isKindOfClass:[NSString class]]) {
        NSString *imagePath = _DKImageDataSource[indexPath.row];        
        NSURL *url = [NSURL URLWithString:imagePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            UIImage *image = [UIImage imageWithData:data];
            cell.DKImageView.image = image; 
        }];
    }
    else {
        NSLog(@"Error: the data source must be (String) URLs to images or images");
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)cview didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    [cview deselectItemAtIndexPath:indexPath animated:NO];
    
    _currentPage = indexPath.item;
    [_DKImageCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}


#pragma mark - UICollectionViewDelegateFlowLayout


- (CGSize)collectionView:(UICollectionView *)cview layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (cview==_DKImageCollectionView) {
        return CGSizeMake(self.DKImageWidth, cview.frame.size.height);
    }
    
    CGSize size;
    size.height = cview.frame.size.height;
    size.width = size.height * _DKImageWidth / _DKImageCollectionView.frame.size.height;
    
    return size;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)cview layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (cview==_DKImageCollectionView) {
        return UIEdgeInsetsMake(0, (self.view.frame.size.width-self.DKImageWidth)/2,
                                0, (self.view.frame.size.width-self.DKImageWidth)/2);
    }
    
    return UIEdgeInsetsMake(0, self.DKImagePadding,
                            0, self.DKImagePadding);
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView==_DKThumbnailCollectionView) {
        return;
    }
    
    scrollView.userInteractionEnabled = NO;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView==_DKThumbnailCollectionView) {
        return;
    }
    
    if (scrollView.isDecelerating) {
        return;
    }
    
    NSInteger item = floor((scrollView.contentOffset.x - self.DKImageWidth / 2) / self.DKImageWidth) + 1;
    
    NSUInteger lastItem = _DKImageDataSource.count - 1;
    
    if (item>_currentPage) {
        _currentPage++;
    }
    else {
        _currentPage--;
    }
    
    if (_currentPage < 0) {
        _currentPage=0;
    }
    
    if (_currentPage>lastItem) {
        _currentPage = lastItem;
    }
    
    [_DKImageCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES ];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView==_DKThumbnailCollectionView) {
        return;
    }
    
    [_DKImageCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES ];
    
    scrollView.userInteractionEnabled = YES;
}


- (void)pickImage:(UIImage*)image{
    UIImagePickerController *photoPickerController = [[UIImagePickerController alloc] init];
    photoPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoPickerController.allowsEditing = NO;
    photoPickerController.delegate = (id)self;
    [self presentViewController:photoPickerController animated:YES completion:nil];
}

#pragma mark - Image Picker Delegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    [self dismissViewControllerAnimated:YES completion:^{
        //self.image = image;
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
        cropController.delegate = self;
        [self presentViewController:cropController animated:YES completion:nil];
    }];
}

#pragma mark - Cropper Delegate -
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    _DKImageDataSource =  [_DKImageDataSource arrayByAddingObject:image];
    [_DKImageCollectionView reloadData];
    [_DKThumbnailCollectionView reloadData];
    
    CGRect rect = [[self.DKImageCollectionView visibleCells] firstObject].frame;
    
    [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:image toFrame:rect completion:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_DKImageDataSource.count-1 inSection:0];
        NSLog(@"IP: %@", indexPath);
        [_DKThumbnailCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        [_DKImageCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Gesture Recognizer -
- (void)didTapImageView{
//    TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:self.image];
//    cropController.delegate = self;
//    [self presentViewController:cropController animated:YES completion:nil];
}


#pragma mark - XLPagerTabStripViewControllerDelegate
-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController{
    return @"Fotos";
}

-(UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController{
    return [UIColor whiteColor];
}

@end
