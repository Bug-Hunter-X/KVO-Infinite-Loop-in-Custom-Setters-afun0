# Objective-C KVO Infinite Loop Bug
This repository demonstrates a subtle bug related to Key-Value Observing (KVO) in Objective-C.  The bug occurs when custom setters for properties have dependencies on each other, creating an infinite loop of KVO notifications.

The `BuggyKVO.m` file showcases the problematic code, while `FixedKVO.m` provides a corrected version.

## Problem
When propertyA is modified, the custom setter updates propertyB, and vice versa. This creates a cyclical dependency resulting in an infinite loop of KVO notifications and a potential application crash.

## Solution
The solution involves carefully managing the KVO notifications.  Avoiding modifications to other KVO-observed properties within the custom setter is the most straightforward approach.  Alternatively, techniques like temporarily disabling KVO or using flags to prevent recursive calls can be employed.