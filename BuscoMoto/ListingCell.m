//
//  ListingCell.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/13/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "ListingCell.h"

@implementation ListingCell

@synthesize listing;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib{
    // Initialization code
}

- (void)prepareForReuse{
    [super prepareForReuse];
}

- (IBAction)likeListing:(id)sender {
    NSLog(@"Liked: %@", self.listing.title);
}
@end
