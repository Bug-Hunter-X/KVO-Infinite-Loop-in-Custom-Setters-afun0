To fix this, avoid modifying other KVO-observed properties within the custom setter. One solution is to use a flag to prevent recursive calls.

```objectivec
@interface MyClass : NSObject
@property (nonatomic, strong) NSString *propertyA;
@property (nonatomic, strong) NSString *propertyB;
@end

@implementation MyClass
- (void)setPropertyA:(NSString *)propertyA {
    if ([propertyA isEqual:_propertyA]) return;
    BOOL kvoSuspended = [self isObservingPropertyA]; // Helper method (see below) 
    if (kvoSuspended) {
      _propertyA = propertyA;
      return;
    }
    [self willChangeValueForKey:@"propertyA"];
    _propertyA = propertyA;
    [self didChangeValueForKey:@"propertyA"];
    //Modified to prevent infinite loop 
    if(propertyA.length > 0) [self setPropertyB:[NSString stringWithFormat:@"B-%@
", propertyA]];
}

- (void)setPropertyB:(NSString *)propertyB {
    if ([propertyB isEqual:_propertyB]) return;   
    BOOL kvoSuspended = [self isObservingPropertyB]; // Helper method (see below)
    if(kvoSuspended) {
      _propertyB = propertyB;
      return;
    }
    [self willChangeValueForKey:@"propertyB"];
    _propertyB = propertyB;
    [self didChangeValueForKey:@"propertyB"];
}

-(BOOL)isObservingPropertyA{
  return [[self observersForProperty:@"propertyA"] count] > 0;
}
-(BOOL)isObservingPropertyB{
  return [[self observersForProperty:@"propertyB"] count] > 0;
}
-(NSArray*)observersForProperty:(NSString*)propertyName{
  return [self observersForKeyPath:propertyName];
}
@end
```
This revised code prevents the infinite loop by conditionally updating `propertyB` based on the length of `propertyA`.