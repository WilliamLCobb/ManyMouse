#import "MenubarController.h"
#import "PanelController.h"
#import "MouseController.h"
@interface ApplicationDelegate : NSObject <NSApplicationDelegate, PanelControllerDelegate>

@property (nonatomic, strong) MenubarController *menubarController;
@property (nonatomic, strong, readonly) PanelController *panelController;
@property MouseController * mouseController;

- (IBAction)togglePanel:(id)sender;

@end
