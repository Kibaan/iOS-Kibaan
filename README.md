[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/hsylife/SwiftyPickerPopover)

KibaanはiOS、Androidアプリの開発を効率化するためのライブラリです。  
主な機能としてiOS、Androidに同じ名前のクラスや関数を用意することで、iOSからAndroidへの機械的なコード変換による移植ができるようにしています。

AndroidはKotlinでの開発を想定しており、SwiftからKotlinへのコード変換は、以下のツールを用いてある程度機械的に行うことができます。

[SwiftKotlin](https://github.com/angelolloqui/SwiftKotlin)

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

# ガイドライン

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
必ず`BaseViewController`を継承すること。

### BaseViewControllerの使い方

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


