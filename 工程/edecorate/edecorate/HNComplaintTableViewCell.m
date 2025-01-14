//
//  HNComplaintTableViewCell.m
//  edecorate
//
//  Created by 刘向宏 on 14-9-20.
//
//

#import "HNComplaintTableViewCell.h"
@interface HNComplaintTableViewCell()

@property (nonatomic, strong)UILabel *roomLabel;
@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)UIImageView *statusImage;
@end

@implementation HNComplaintTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.roomLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, 0, self.bounds.size.width * 0.8, 36)];
        self.roomLabel.top = 9;
        self.roomLabel.numberOfLines = 2;
        self.roomLabel.font = [UIFont systemFontOfSize:15];
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.roomLabel.frame) + 8, self.bounds.size.width * 0.8, 14)];
        self.statusLabel.left = self.roomLabel.left;
        self.statusLabel.bottom = self.contentView.height - 14;
        self.statusLabel.font = [UIFont systemFontOfSize:14];
        self.statusLabel.textColor = [UIColor colorWithWhite:128.0/255.0 alpha:1.0];
        
        self.statusImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.statusImage.left = 12;
        self.statusImage.top = 23;
        
        [self.contentView addSubview:self.statusImage];
        [self.contentView addSubview:self.roomLabel];
        [self.contentView addSubview:self.statusLabel];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.statusLabel.top = self.roomLabel.bottom +3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setRoomName:(NSString *)roomname{
    self.roomLabel.text = roomname;
}
- (void)setStatus:(NSString *)status{
    if (status&&[status length]) {
        self.statusLabel.text = @"业主已回复";
        self.statusImage.image = [UIImage imageNamed:@"accept.png"];
    }
    else{
        self.statusLabel.text = @"业主未回复";
        self.statusImage.image = [UIImage imageNamed:@"unsubmit.png"];
    }
}


@end
