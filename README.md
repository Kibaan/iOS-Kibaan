[![CocoaPods Compatible](https://img.shields.io/badge/pod-compatible-green.svg)](https://cocoapods.org/pods/Kibaan)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# Kibaanの概要
KibaanはiOS、Androidアプリの開発を効率化するためのライブラリです。  
主に以下の機能を提供します。

## SwiftとKotlinの差異の吸収

Kibaanを利用する場合、プログラミング言語はiOS側がSwift、Android側がKotlinの前提になります。  
KibaanはSwiftとKotlin間の差異を可能な限り吸収しています。

例えば、SwiftのStringクラスは`count`プロパティで文字数を取得できますが、Kotlinでは`length`プロパティで文字数を取得するため、Android側のKibaanにはiOSと同名の`String.count`プロパティを用意し、iOSとAndroidが同名のプロパティで文字数を取得できるようにしています。

## SwiftからKotlinへの機械的な変換

[SwiftKotlin](https://github.com/angelolloqui/SwiftKotlin) を使って、Swiftのコードはある程度機械的にKotlinに変換することができます。  
そのため、Kibaanを使った開発ではiOS側の実装を先に行い、その後にAndroid側の開発を行うことを推奨します。


## 画面制御
Kibaanは画面遷移の機能を提供します。  
これは、iOSにおける`Segue`や`UINavigationController`、`presetnViewController`などによる画面遷移を肩代わりするもので、Kibaanを使うことで、iOSもAndroidも画面遷移処理のコードを同様にすることができます。

また、KibaanはAndroid側に`UIViewController`と類似の機能を提供します。これにより画面や画面遷移のコードをiOSとAndroidで同様にすることができます。

## UIクラス

Kibaanはテキスト、ボタン、テーブルビュー、スクロールビューなどの基本的なUIクラスを提供します。  
これはiOS標準のUILabel、UIButton、UITableViewなどのクラスをラップするもので、OS標準の機能に角丸やパディングなど、よく使う一般的な機能を少し足したものになります。

これらのUIクラスはAndroid側にも同名のクラスが用意されており、これを使うことでUI周りのコードをiOSとAndroidで同様にすることができます。

## 共通のフォント管理

Kibaanの提供するUIクラスは一律でフォントファミリーを変更することができます。  
アプリケーション共通で通常フォントと太字フォントを指定すると、全てのUIクラスに対してフォントを設定することができます。

## ユーティリティー

その他、Kibaanはアプリ開発において基本的な以下のような機能を提供します。

- HTTP通信
- 端末内データベース（UserDefaults、SharedPreferences、Realmなどの代替機能）
- データのセキュアな保存
- アラートダイアログの表示
- クエリパラメータのパース


# 動作環境

<dl>
	<dt>最小サポートOS</dt>
	<dd>iOS10.0</dd>
</dl>


# プログラミングガイド

## AppDelegate

AppDelegateは SmartAppDelegateを継承させてください。

## テキスト表示

UILabelなどテキストを持つUIは、UILableなどの標準クラスを使用せず、代わりに以下のSmart系クラスを使用する。

- SmartLabel
- SmartButton
- SmartTextField
- SmartTextView

これらのクラスを使用すると、アプリ全体でフォントを共通して管理できる。  
共通フォントはSmartContextのシングルトンに設定し、
外部フォントを追加する場合、info.plistのFonts provided by applicationにフォントファイル名を記載する必要があるので注意

## 画面遷移

画面遷移は基本的にScreenServiceクラスにて行う。

### ルート画面の切り替え

```
ScreenService.instance.setRoot(SampleViewController.self)
```
### サブ画面を上に乗せる

```
ScreenService.instance.addSubScreen(FontTestViewController.self)
```
サブ画面を上に乗せた場合は、遷移元画面の`onLeaveForeground `が呼ばれる。  
※裏が透けるオーバーレイ表示の場合は`BaseViewController.addOverlay`を使用する

### サブ画面を閉じる

```
ScreenService.instance.removeSubScreen()
```

### 画面遷移時にデータを渡す

画面遷移時に遷移先のViewControllerに何らかのデータを渡す場合は、prepare引数を使用する。

## 画面表示
Kibaanの画面遷移機能を使うには、ViewControllerは`SmartViewController`を継承する必要がある。

### SmartViewControllerの使い方

画面がスクリーンに追加されたときに処理をしたい場合は`onAddedToScreen`をoverrideする。  

```
func onAddedToScreen() {
	super.onAddedToScreen()
	// 画面がスクリーンに追加された時に実施する処理
}
```

画面がフォアグラウンド状態になったときに処理をしたい場合は`onEnterForground`をoverrideする。  
`onAddedToScreen`とは異なり、オーバーレイの画面を取り除いて戻った際にも呼ばれる点に注意。

```
override func onEnterForeground() {
    super. onEnterForeground()
	// 画面がフォアグラウンド状態になったときに実施する処理
}    
```

画面がスクリーンから取り除かれたときに処理をしたい場合は`onRemovedFromScreen`をoverrideする。  

```
override func onRemovedFromScreen() {
    super.onRemovedFromScreen()
    // 画面がスクリーンから取り除かれたときに実施する処理
}
```


画面がフォアグラウンド状態から離脱したときに処理をしたい場合は`onLeaveForeground`をoverrideする。  
`onRemovedFromScreen`とは異なり、オーバーレイで画面を乗せた場合も呼ばれる点が異なる。

```
override func onLeaveForeground() {
    super. onLeaveForeground()
	// 画面がフォアグラウンド状態から離脱したときに実施する処理
}
```

### オーバーレイ表示の方法
ダイアログなど裏の画面が透けて見えるUIをオーバーレイ表示する場合は、BaseViewControllerの`addOverlay`を使用する。  
オーバーレイ表示は`ScreenService.addSubScreen`と異なり、親画面の`onLeaveForeground`が呼ばれない。  
もし、裏の画面が完全に見えなくなり、フルスクリーンで画面を表示する場合は`ScreenService.addSubScreen`を使用する

```
addOverlay(◯◯◯◯ViewController.self)
```

### 画面のキャッシュについて
`ScreenService`を使用して画面表示をした場合は、標準ではViewControllerがクラス毎に１つキャッシュされる。  
同じViewControllerクラスのインスタンスを複数作りたい場合は、`addSubscreen`などの引数に`id`を指定する。

### タブ区切りなど１つの画面で複数の子画面を持たせる
`commonInit()`をoverrideした上で、以下のようにコントローラを登録する。

```
override func commonInit() {
    super.commonInit()
    addSubControllers(Array(controllerMap.values))
}
```
or

```
override func commonInit() {
    super.commonInit()
    addSubController(sampleViewController1)
    addSubController(sampleViewController2)
}
```
また、`foregroundSubControllers`をoverrideし、現在表示しているビューコントローラの配列を返す必要がある。
※これを忘れると子画面の`onStart()`が呼ばれない為、注意が必要

```
override var foregroundSubControllers: [BaseViewController] {
	return [currentController]
}
```

## SmartTableView

SmartTableViewはregisterCellClassで事前にCellのクラスを登録し、tableView(tableView:cellForRowAt)にて、registeredCellで登録したCellを取得する。  
登録するCellクラスはUITableViewCellを継承し、クラスと同名のxibファイルを設けて、xibのViewのクラスをCellクラスに設定する必要がある。

```
    @IBOutlet weak var tableView: SmartTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellClass(SampleCell.self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let table = tableView as? SmartTableView else { return UITableViewCell() }
        
        let cell = table.registeredCell(indexPath, type: SampleCell.self)
        return cell
    }
```

## 端末に保存する設定

端末に保存する設定は機能に応じたLocalSettingのサブクラスで保存する。  
アプリ再起動後も利用する必要がある情報のみ保存し、アプリ起動中しか必要のない情報は保存しないよう注意する。

## アラートの表示

アラートの表示にはAlertUtilsクラスを使用する。

## メッセージの管理
アプリで表示するメッセージは`Localizable.strings`に記述し、以下のような記述で参照する。

***Localizable.strings***  

```
"msg_0001" = "ログインの有効期限が切れました。";
```
***使用方法***

```
"msg_0001".localizedString
```

## Enumの定義
アプリ共通的に使用するコード値や種別は`App/Constant/EnumType`直下にEnumクラスを追加する。  
対応するコード値がある場合は`rawValue`に設定する。

***サンプル***

```
/// 売買タイプ
enum BuySell: String {
    case buy    = "3"   // 買
    case sell   = "1"   // 売
}
```

## Extension
基本的なクラスの汎用的な機能はExtensionとして実装されています。  
実装を開始する前にひと通り確認してください。

# CocoaPodsアップデート方法

1. `Kibaan.podspec`に記載された`s.version`を更新する
2. GitHubにPUSHする
3. GitHubで1に記載したバージョンと同じバージョンのリリースを作成する
4. CocoaPodsサーバーに`Kibaan.podspec`をアップロードする

```
pod trunk push Kibaan.podspec
```

4を行うには事前にPodへのユーザー登録が必要になる。  
同じユーザーで登録可能なのか不明。

```
pod trunk register info@altonotes.co.jp 'altonotes Inc.'
```

