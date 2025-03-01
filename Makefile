# SPDX-License-Identifier: MIT
# Copyright 2025 hirmiura (https://github.com/hirmiura)
#
SHELL := /bin/bash


#==============================================================================
# カラーコード
# ヘルプ表示
# ディレクトリチェック
#==============================================================================
include ColorCode.mk
include Help.mk
include Check.mk


#==============================================================================
# Ja.edit.poをJa.poにマージする
#==============================================================================
.PHONY: merge-editpo
merge-editpo: ## Ja.edit.poをJa.poにマージする
merge-editpo: Ja.po

Ja.po: Ja.edit.po
	msgcat --use-first --no-location --no-wrap -o Ja.po Ja.edit.po Ja.po
	msgattrib --no-obsolete --no-location --no-wrap --sort-output -o - Ja.po \
	| grep -vE '^"(Project-Id-Version|POT-Creation-Date|Last-Translator|X-Generator):.*\\n"' \
	| sponge Ja.po


#==============================================================================
# Ja.csvを生成する
#==============================================================================
.PHONY: gen-jacsv
gen-jacsv: ## Ja.csvを生成する
gen-jacsv: Ja.csv

Ja.csv: Ja.po
	poetry run src/csff_mod_ja/po2csv.py -i Ja.edit.po -o Ja.csv


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
all: build
