# SPDX-License-Identifier: MIT
# Copyright 2025 hirmiura (https://github.com/hirmiura)
#
SHELL := /bin/bash

# 各種ディレクトリ/ファイル
D_CSFF_LOC	:= csff_Localization


#==============================================================================
# カラーコード
# ヘルプ表示
# ディレクトリチェック
#==============================================================================
include ColorCode.mk
include Help.mk
include Check.mk


#==============================================================================
# 各種確認
#==============================================================================
.PHONY: check
check: ## 事前にチェック項目を確認する
check: check_link


#==============================================================================
# Elin へのリンク/ディレクトリを確認
#==============================================================================
.PHONY: check_link
check_link: ## cstt本体のLocalizationへのリンク/ディレクトリを確認する
check_link:
	$(call check.linkordir,$(D_CSFF_LOC))


#==============================================================================
# En.csvを生成する
#==============================================================================
.PHONY: gen-encsv
gen-encsv: ## Ja.potを生成する
gen-encsv: En.csv

En.csv: $(D_CSFF_LOC)/Kr.csv
	poetry run src/csff_mod_ja/encsv.py -i $< -o $@


#==============================================================================
# Ja.potを生成する
#==============================================================================
.PHONY: gen-pot
gen-pot: ## Ja.potを生成する
gen-pot: Ja.pot

Ja.pot: En.csv
	poetry run src/csff_mod_ja/csv2pot.py -i $< -o $@


#==============================================================================
# Ja.edit.poをJa.poにマージする
#==============================================================================
.PHONY: merge-editpo
merge-editpo: ## Ja.edit.poをJa.poにマージする
merge-editpo: Ja.po

Ja.po: Ja.edit.po
	msgcat --use-first --no-location --no-wrap -o $@ $< $@
	msgattrib --no-obsolete --no-location --no-wrap --sort-output -o - $@ \
	| grep -vE '^"(Project-Id-Version|POT-Creation-Date|Last-Translator|X-Generator):.*\\n"' \
	| sponge $@


#==============================================================================
# Ja.csvを生成する
#==============================================================================
.PHONY: gen-jacsv
gen-jacsv: ## Ja.csvを生成する
gen-jacsv: Ja.csv

Ja.csv: Ja.po
	poetry run src/csff_mod_ja/po2csv.py -i $< -o $@


#==============================================================================
# ビルド
#==============================================================================
.PHONY: build
build: ## ビルドする
build: merge-editpo gen-jacsv


#==============================================================================
# 全ての作業を一括で実施する
#==============================================================================
.PHONY: all
all: ## 全ての作業を一括で実施する
all: check gen-encsv gen-pot build
