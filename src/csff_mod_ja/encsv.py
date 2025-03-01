#!/usr/bin/env -S python
# SPDX-License-Identifier: MIT
# Copyright 2025 hirmiura (https://github.com/hirmiura)
"""任意言語のcsvファイルから英語版のcsvファイルを生成する。"""

from __future__ import annotations

import argparse
import csv
import os
import sys


def pargs() -> argparse.Namespace:
    """コマンドライン引数を処理する

    Returns:
        argparse.Namespace: 処理した引数
    """
    parser = argparse.ArgumentParser(
        description="任意言語のcsvファイルから英語版のcsvファイルを生成する。"
    )
    parser.add_argument(
        "-i",
        metavar="INPUT",
        type=argparse.FileType("r", encoding="utf-8-sig"),
        default="-",
        help="入力ファイル。指定されなければ標準入力",
    )
    parser.add_argument(
        "-o",
        metavar="OUTPUT",
        type=argparse.FileType("w", encoding="utf-8"),
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
    reader = csv.reader(args.i)
    writer = csv.writer(args.o)
    try:
        for row in reader:
            writer.writerow([*row[0:2], row[1]])
    except BrokenPipeError:
        # パイプが切れた時のエラーを消す
        devnull = os.open(os.devnull, os.O_WRONLY)
        os.dup2(devnull, sys.stdout.fileno())
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
