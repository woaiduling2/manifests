- ## summary
  - this is a user to comile LineageOS-20.0(android 13) for pixel 4 on crave.io's note.
  - device
      - pixel4
  - environment
    - windows 10
    - ubuntu-22.04 base on wsl2
  - as far as I know  
    - devspace is a remote place to run 'crave run' command,don't do other things in devspace to avoid ban.
    - don't use rm -rf Lineage20,otherwise your account will be ban.
        - need a new container for your development,please use crave discard and wait the successful email send to you.
        - need a new Lineage20 template folder,please use crave clone destroy.
    - don't use soong_ui in devspace,otherwise your account will be ban. 
    - git clone a repo,recommand use --depth 1
    - don't use repo sync,recommand use /opt/crave/resync.sh better.
    - don't use m clean/mka clean/make clean,otherwise your account will be ban.
    - dont't use -j value,otherwise your account will be ban.
    - crave run once,received successful/fail email once,don't run twice for you compile.
    - perhaps there are other rules in the wiki,but they rarely lead to ban.

- ## everything should be based on the official wiki.
  - [offical wiki](https://fosson.top/crave/getting-started/introduction.html)

- ## base my experience
  - 1.enter devspace
    - ```
      ./crave-0.2-7220-linux-amd64.bin  -n -c crave.conf devspace
      ```
  - 2.create template(don't modify Lineage20,the wiki recommand we use this directory name)
    - ```
      crave clone create Lineage20 --projectID 36
      ```
  - 3.success command base my experience,may be not beautiful
    - why i use rm -rf out/soong/.intermediates,beacuse crave.io container prompt me disk space exhaust
    - why i rm -rf vendor/google/flame vendor/google/coral,because resync.sh didn't sync it,cause a compile err
    - why i replace [TheMuppets/manifests](https://github.com/TheMuppets/manifests) to [woaiduling2/manifests](https://github.com/woaiduling2/manifests) beacuse it download many other device vendor,and exhaust disk space
    - ```
      cd Lineage20
      crave -n run --detached --no-patch -- "df -h;\
      rm -rf out/soong/.intermediates;\
      wget https://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2_amd64.deb && sudo dpkg -i libtinfo5_6.3-2_amd64.deb && rm -f libtinfo5_6.3-2_amd64.deb;\
      wget https://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libncurses5_6.3-2_amd64.deb && sudo dpkg -i libncurses5_6.3-2_amd64.deb && rm -f libncurses5_6.3-2_amd64.deb;\
      rm -rf .repo/local_manifests;\
      git clone https://github.com/woaiduling2/manifests --depth 1 -b lineage-20.0 .repo/local_manifests;\
      rm -rf vendor/google/flame vendor/google/coral;\
      /opt/crave/resync.sh;\
      source build/envsetup.sh;\
      mka installclean;\
      df -h;\
      du -sh out/* | sort -h;\
      du -sh out/soong/* | sort -h;\
      du -sh vendor/* | sort -h;\
      du -sh device/* | sort -h;\
      du -sh kernel/* | sort -h;\
      brunch flame;\
      du -sh out/* | sort -h;\
      du -sh out/soong/* | sort -h;\
      du -sh vendor/* | sort -h;\
      du -sh device/* | sort -h;\
      du -sh kernel/* | sort -h;\
      df -h"
      ```
  - 4.After the last step succeeds, we can upload the target zip to GitHub Releases(Be careful,the release title don't use blank,offical script dont't support it,just use 'official-flame' otherwise 'official flame'
    - ```
      cd Lineage20
      crave -n run --detached --no-patch -- "df -h;\
      wget https://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2_amd64.deb && sudo dpkg -i libtinfo5_6.3-2_amd64.deb && rm -f libtinfo5_6.3-2_amd64.deb;\
      wget https://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libncurses5_6.3-2_amd64.deb && sudo dpkg -i libncurses5_6.3-2_amd64.deb && rm -f libncurses5_6.3-2_amd64.deb;\
      source build/envsetup.sh;\
      mka installclean;\
      df -h;\
      du -sh out/* | sort -h;\
      du -sh out/soong/* | sort -h;\
      du -sh vendor/* | sort -h;\
      du -sh vendor/google/* | sort -h;\
      du -sh vendor/google/flame/* | sort -h;\
      du -sh device/* | sort -h;\
      du -sh kernel/* | sort -h;\
      brunch flame && bash /opt/crave/github-actions/upload.sh 'flame-v.0.0.1' 'flame' 'https://github.com/woaiduling2/manifests' 'official-flame';\
      du -sh out/* | sort -h;\
      du -sh out/soong/* | sort -h;\
      du -sh vendor/* | sort -h;\
      du -sh vendor/google/* | sort -h;\
      du -sh vendor/google/flame/* | sort -h;\
      du -sh device/* | sort -h;\
      du -sh kernel/* | sort -h;\
      df -h"
      ```
      
  - 5.after previous step success,we can simply command like below.
    - ```
      cd Lineage20
      crave -n run --detached --no-patch -- "rm -f out/target/product/flame/*.zip out/target/product/flame/*.img;\
      source build/envsetup.sh;\
      brunch flame && bash /opt/crave/github-actions/upload.sh 'flame-v.0.0.1' 'flame' 'https://github.com/woaiduling2/manifests' 'official-flame';\
      df -h"
      ```
      
- ## small tips
  - don't use cat xxx.txt in crave run command,crave will check your command,and then just return 1 err.
  - When the queue is heavy, `crave run` may also return exit code 1 (error). This could be due to the administrator or the Crave server causing some runs to fail. If this happens, simply re-run the command and be patient.
