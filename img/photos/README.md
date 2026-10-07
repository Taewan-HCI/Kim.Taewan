# 홈페이지 사진 타일 ("Off Work")

홈페이지의 Experience | Education 오른쪽에 있는 사진 타일을 관리하는 방법입니다.

## 동작 방식

- 이 폴더의 `tile-*.jpg` 파일이 전부 자동으로 타일 후보가 됩니다. 사진을 추가하거나 뺄 때 HTML은 고칠 필요가 없습니다.
- 화면에는 항상 6칸(2열 × 3행)만 보입니다. 처음 보이는 6장은 파일명 알파벳순으로 앞의 6장입니다.
- 약 4초마다 한 칸이 2.4초에 걸쳐 다른 사진으로 페이드됩니다.
  - 사진이 7장 이상이면 화면에 없는 사진이 한 칸씩 들어옵니다.
  - 6장 이하이면 두 칸이 서로 자리를 바꿉니다.
- 기기에서 "동작 줄이기"를 켠 방문자에게는 전환 없이 고정된 타일로 보입니다.
- 타일은 장식용이라 클릭 동작이 없고 `alt`는 비워 둡니다. (눌러서 크게 보는 기능은 넣었다가 뺐습니다.)

## 사진 추가하기

1. 원본을 `img/photos/originals/`에 넣습니다. 이 폴더는 `.gitignore`에 있어 배포되지 않습니다.
2. 정사각형 440px 타일을 만들어 `img/photos/tile-<이름>.jpg`로 저장합니다. 이름은 영문 소문자로 짓습니다.

   ```bash
   cd img/photos
   src=originals/IMG_1234.jpg   # 원본
   out=tile-seoul.jpg           # 타일 파일명

   w=$(sips -g pixelWidth "$src" | awk '/pixelWidth/{print $2}')
   h=$(sips -g pixelHeight "$src" | awk '/pixelHeight/{print $2}')
   if [ "$w" -ge "$h" ]; then
     sips --resampleHeight 440 -s format jpeg -s formatOptions 80 "$src" --out "$out"
   else
     sips --resampleWidth 440 -s format jpeg -s formatOptions 80 "$src" --out "$out"
   fi
   sips -c 440 440 "$out"       # 가운데 기준으로 정사각형 자르기
   ```

3. 가운데로 자르면 주제가 잘리는 사진은 마지막 줄 대신 위치를 지정해서 자릅니다. 값은 `위에서 떨어진 px`, `왼쪽에서 떨어진 px` 순서입니다. 0은 가운데로 처리되므로 가장자리에 붙이려면 1을 씁니다.

   ```bash
   sips -c 440 440 --cropOffset 1 20 "$out"
   ```

   `tile-camping.jpg`가 이 방식으로 왼쪽 기준(`1 20`)으로 잘려 있습니다.

4. 로컬에서 확인한 뒤 `tile-*.jpg`만 커밋합니다.

사진을 빼려면 해당 `tile-*.jpg`를 지우면 됩니다.

## 고를 때 주의할 점

- 공개 사이트이므로 다른 사람 얼굴이 또렷하게 나온 사진은 피하거나, 얼굴이 빠지도록 자릅니다.
- 타일 하나는 60~90KB 정도가 적당합니다.

## 관련 코드

| 무엇 | 어디 |
|---|---|
| 타일 목록을 만드는 Liquid, 6칸 마크업 | `index.html`의 `photo-grid` 부분 |
| 전환 스크립트 (간격 `4200`ms, 이전 사진 제거 `2600`ms) | `index.html`의 "Photo tiles" 스크립트 |
| 칸 크기·간격(`gap: 3px`), 페이드 시간(`photo-in 2.4s`) | `stylesheets/styles.css`의 `.photo-grid`, `.photo-slot` |
| 3열 배치와 좁은 화면에서의 접힘 | `stylesheets/styles.css`의 `.trio` |

페이드 시간을 바꾸면 스크립트의 이전 사진 제거 시간(`2600`)도 그보다 조금 길게 맞춰야 전환 중에 칸이 비지 않습니다.

## 로컬 확인

저장소 루트에서 `./serve.sh`를 실행하고 http://localhost:4000 을 엽니다. 브라우저가 예전 페이지를 보여 주면 강력 새로고침(Cmd + Shift + R)을 합니다.
