# csff-mod-ja

[Card Survival: Fantasy Forest] の私家版和訳  
簡体字版乗っ取り方式

## インストール方法

1. [Ja.csv](
https://raw.githubusercontent.com/hirmiura/csff-mod-ja/main/Jp.csv) をダウンロードし  
`Card Survival Fantasy Forest/Card Survival - Fantasy Forest_Data/StreamingAssets/Localization/Cn.csv` に上書きコピーする。
2. ゲームを起動し、言語設定を**簡体中文**に変更する
3. ゲームを再起動する

## 翻訳手順忘備録

```bash
encsv.py -i 本体/Kr.csv -o En.csv
csv2pot.py -i En.csv -o Ja.pot
msginit --no-translator -l ja_JP.utf8 -i Ja.pot -o Ja.edit.po
```

`Ja.edit.po` を翻訳

```bash
msgfmt --statistics -o Ja.mo Ja.edit.po
mo2csv.py -i Ja.mo -o Ja.csv
```

## マージ

```bash
msgmerge --no-fuzzy-matching --no-location --no-wrap --backup=t -U Ja.po new.pot
msgcat --use-first --no-location --no-wrap -o Ja.po Ja.edit.po Ja.po
```

### git用に簡略化する

```bash
msgattrib --no-obsolete --no-location --no-wrap --sort-output -o - Ja.po \
| grep -vE '^"(POT-Creation-Date|X-Generator):.*\\n"' \
| sponge Ja.po
```

## ライセンス

[MIT License] としています。  
ご自由にお使いください。

---

[Card Survival: Fantasy Forest]: https://store.steampowered.com/app/2868860/Card_Survival_Fantasy_Forest/
[MIT License]: https://opensource.org/license/mit/
