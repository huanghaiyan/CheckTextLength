//写出中英文混排的字符串长度方法；用户名通过该方法检测用户输入的文字长度，超出则限制输入；密码通过所给正则表达式限制输入格式。
#import "ViewController.h"

#define kMaxLength 20   //用户名字数限制

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;//用户名输入框
@property (weak, nonatomic) IBOutlet UITextField *pswTextField; //密码输入框
- (IBAction)detectLength:(id)sender;    //点击注册的响应事件

@end

@implementation ViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.nameTextField];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:self.nameTextField];
}

- (NSUInteger)getStringLength:(NSString *)tempString{
    //No.1
    //开始写代码，获取字符串的长度（此处需考虑中英文混排的长度检测）
    NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [tempString dataUsingEncoding:encode];
    NSUInteger dateLength = [data length];
    return dateLength;
    //end_code
}

- (void)textFieldEditChanged:(NSNotification *)obj{
    UITextField * textField = obj.object;
    NSString * textStr = textField.text;
    
    //No.2
    //开始写代码，输入时检测用户输入的文字长度，当达到一定的限度(kMaxLength)的时候，提示@"用户名不能大于20个字符"，并限制输入。
    UITextRange * range = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:range.start offset:0];
    NSUInteger length = [self getStringLength:textStr];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (length > kMaxLength) {
            textField.text = [textStr substringToIndex:kMaxLength];

            [self showAlert:@"用户名不能大于20个字符"];
        }
    }
    
    
    //end_code
}

- (IBAction)detectLength:(id)sender {
    if (_nameTextField.text.length == 0) {
        [self showAlert:@"用户名不能为空"];
        return;
    }
    
    NSString * regex = @"^[A-Za-z0-9]{6,15}$";
    //No.3
    //开始写代码，通过所给正则表达式，限制密码的输入格式
    
    BOOL isMatch =  [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex] evaluateWithObject:self.pswTextField.text];
    //end_code
    if (!isMatch) {
        [self showAlert:@"密码格式不正确"];
        return;
    }
    [self showAlert:@"注册成功！"];
}

- (void)showAlert:(NSString *)message{
    [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end