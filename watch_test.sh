#!/bin/sh

LOG_PATH='/c/Users/tsrm/OneDrive/ドキュメント/SEGA/PHANTASYSTARONLINE2/log'
timestamp=`date '+%Y%m%d'`
FILE_NAME="ChatLog${timestamp}_00.txt"
FILE_PATH="${LOG_PATH}/${FILE_NAME}"
# FILE_PATH="./test.txt"

cnt() {
  echo `wc -l ${FILE_PATH} | awk '{print $1}'`
}

# 監視間隔, 秒で指定
INTERVAL=1 
# イテレータ
no=0
# 行数カウンタ
last=`cnt ${FILE_PATH}`


if [ -f "${FILE_PATH}" ];
then
  echo "start watching: ${FILE_PATH}"
else
  echo 'file does not exists.'
  exit
fi

while true;
do
  # 一定時間ごとに行数を取得
  sleep $INTERVAL
  current=`cnt ${FILE_PATH}`

  # 行数が変わってたら
  if [ "${last}" != "${current}" ];
  then 
    cnt_diff=`expr ${current} - ${last}`
    txt_diff=`./nkf32.exe -w  ${FILE_PATH} | tail --lines=${cnt_diff}`
    echo "${no}| cnt_diff:"${cnt_diff}", txt_diff:"${txt_diff}
    
    pattern='ゆりかご'
    if [ "`./nkf32.exe -w  ${FILE_PATH} | tail --lines=${cnt_diff} | grep ${pattern}`" ];
    then
      ./yukarisan.bat &
    fi

    # 最新の行数で更新
    last=${current}
    # イテレータ
    no=`expr ${no} + 1`
  fi  
done