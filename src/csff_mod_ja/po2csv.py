#!/usr/bin/env -S python
# SPDX-License-Identifier: MIT
# Copyright 2025 hirmiura (https://github.com/hirmiura)
"""poファイルからcsvファイルを生成する。"""

from __future__ import annotations

import argparse
import csv
import os
import sys

import polib


def pargs() -> argparse.Namespace:
    """コマンドライン引数を処理する

    Returns:
        argparse.Namespace: 処理した引数
    """
    parser = argparse.ArgumentParser(description="poファイルからcsvファイルを生成する。")
    parser.add_argument(
        "-i",
        metavar="INPUT",
        # type=argparse.FileType("r", encoding="utf-8-sig"),
        default="-",
        help="入力ファイル",
    )
    parser.add_argument(
        "-o",
        metavar="OUTPUT",
        type=argparse.FileType("w", encoding="utf-8-sig"),
        default="-",
        help="出力ファイル。指定されなければ標準出力",
    )
    parser.add_argument("--version", action="version", version="%(prog)s 0.1.0")
    args = parser.parse_args()
    return args


def main() -> int:
    """メイン関数

    Returns:
        int: 成功時は0を返す
    """
    args = pargs()
    pofile = polib.pofile(args.i, encoding="utf-8-sig")
    writer = csv.writer(args.o)

    # poファイルのエントリーをまわす
    try:
        for entry in pofile:
            ctxt = entry.msgctxt
            if not ctxt:  # コンテキストがなければスキップ
                continue
            msgid = entry.msgid or ""
            msgstr = entry.msgstr or msgid
            writer.writerow([ctxt, msgid, msgstr])  # 書き出す
    except BrokenPipeError:
        # パイプが切れた時のエラーを消す
        devnull = os.open(os.devnull, os.O_WRONLY)
        os.dup2(devnull, sys.stdout.fileno())
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
