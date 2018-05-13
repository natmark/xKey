![Header](https://github.com/natmark/xKey/blob/master/Resources/xKey-header.png?raw=true)

---
<h1><img src="https://github.com/natmark/xKey/blob/master/Resources/icon.png?raw=true" width="4%">&nbsp;xKey</h1>
&nbsp;

xKey is a Cocoa key handler extension for OSX written in Swift :penguin:


## Examples
1. Operate in order of keyDown(K), keyDown(L), keyUp(L).
![GIF](https://github.com/natmark/xKey/blob/master/Resources/xKey-example.gif?raw=true)

- When not using xKey, keyDown(K) event does not fire in spite of K key is pressing.
  - keyDown(K)→keyDown(L)→keyUp(L)→ not to call keyDown(K)

- When using xKey, xKey trigger a keyDown(K) event automatically.
  - keyDown(K)→keyDown(L)→keyUp(L)→keyDown(K)


## Usage

## Instration
### [CocoaPods](http://cocoadocs.org/docsets/xKey/)
Add the following to your `Podfile`:
```
  pod "xKey"
  pod "xKey"
```

### [Carthage](https://github.com/Carthage/Carthage)
Add the following to your `Cartfile`:
```
  github "natmark/xKey"
  github "natmark/xKey"
```

## License
xKey is available under the MIT license. See the LICENSE file for more info.
