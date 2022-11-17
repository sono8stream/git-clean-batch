# Untitled

Date: November 13, 2022

- Gitlab 立ち上げ、push サイズ制限を確認する
  - 立ち上げ
    - docker を wsl にインストール
    - docker pull で gitlab-ee を取得 or https://drive.google.com/file/d/11qI6L2u1Ckpyuu9w7ps11RBjQNVWyw8J/view?usp=sharing
    - [https://docs.gitlab.com/ee/install/docker.html](https://docs.gitlab.com/ee/install/docker.html)　の docker-engine のセットアップを参考に gitlab 環境を立ち上げ
    - localhost で gitlab にアクセスできることを確認
    - ユーザ追加
    - nano のインストール
    - SMTP サーバを立ち上げておく
      - [https://qiita.com/South\_/items/a4041f6e393de6ff556b](https://qiita.com/South_/items/a4041f6e393de6ff556b)
    - メールサーバ修正
      - [SMTP settings | GitLab](https://docs.gitlab.com/omnibus/settings/smtp.html)
      - [https://mebee.info/2021/05/17/post-32838/](https://mebee.info/2021/05/17/post-32838/)
  - 懸念点
    - ユーザ登録などが面倒くさい。管理者がいちいち手作業か？
    - ユーザ登録メールが出せない？
      - 登録後にパスワードを与えることで対応できるので、最悪これで
      - メールを送れることが本質では無かろう
    - 日本語 →OK
    - 一般ユーザでも public リポジトリ作れちゃう
      - Project 作成をできなくすればいい。
      - 管理者権限が必要だが…
      - まあ重要項目にアクセスできないならいいだろう。社外に出ていくわけではないので。
      - いやでもコピーしてプッシュされるのよくないよな
      - 設定で public 選べないことが判明。OK！
    - プライベートなリポジトリが作れてしまう
      - Projects limit を 0 にすればグループ以外でプロジェクトを作れなくなるから OK。これはデフォルト設定で可能
    - サイズ問題
      - 2GB は余裕
      - とりあえず 10GB くらいまでは試してみよう
      - OK！
        ![Untitled](Untitled%20de1766fded5e4a0d85422c0af2de4e08/Untitled.png)
    - あとは
      - [x] Jira 連携
      - [x] 外部 PC アクセス
      - [ ] メール送信（追々でも OK）
    - 何はともあれ、先に展開したほうがいい
  - 所感
    - とりあえずやろうで着手できるのがかなりいいね
  - 発見
    - Gitlab では Group の中で Project や Repository を管理するのね
  - IP アドレスを外部に公開する方法？
    - WSL 内で ip r を行い、アクセスする
    - 最小構成は以下？
      - [https://www.kouken-party.info/2020/01/08/wsl2 上のサーバーに外部からアクセスする/](https://www.kouken-party.info/2020/01/08/wsl2%E4%B8%8A%E3%81%AE%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC%E3%81%AB%E5%A4%96%E9%83%A8%E3%81%8B%E3%82%89%E3%82%A2%E3%82%AF%E3%82%BB%E3%82%B9%E3%81%99%E3%82%8B/)
    - 追加
      - netsh interface portproxy add v4tov4 listenport=80 listenaddress=0.0.0.0 connectport=80 [connectaddress=172.x.xx.xxx](http://connectaddress%3D172.x.xx.xxx/)
    - 削除
      - netsh interface portproxy delete v4tov4 listenport=80 listenaddress=0.0.0.0
    - ポートが埋まっていると通信できないので、注意
  - Jira 連携
    - 2 つある。Jira から Gitlab 向けのものと、Gitlab から jira 向けのもの
    - Gitlab から設定するもの
      - [https://docs.gitlab.com/ee/integration/jira/configure.html](https://docs.gitlab.com/ee/integration/jira/configure.html)
      - 設定後、Gitlab で作った文字列からリンクが生成される
    - Jira から設定するもの
      - [https://docs.gitlab.com/ee/integration/jira/connect-app.html#install-the-gitlabcom-for-jira-cloud-app-for-self-managed-instances](https://docs.gitlab.com/ee/integration/jira/connect-app.html#install-the-gitlabcom-for-jira-cloud-app-for-self-managed-instances)
      - そもそも、まずは Gitlab 側に外部からアクセスできるようにする必要がある
        - ドメイン設定を行う。Windows キー+R で drivers を実行し、etc/hosts にドメイン名を追加する。VS Code を利用すると、管理者権限で保存できる。
          etc/hosts
          `<windows側のIPアドレス> gitlab.example.com`
        - これだけだとだめ。Config でコメントアウトしておく必要あり
        - コメントアウトしてもダメっぽい
        - 面倒くさそうなので、DVCS を試してみよう
          ![Untitled](Untitled%20de1766fded5e4a0d85422c0af2de4e08/Untitled%201.png)
      - DVCS でも URL が必要っぽい。まあそれはそう
      - とりあえず Jira 側にリンクを足すことはできたので、これで最低限は大丈夫そう。ただし DNS 解決できていないので、リンクから飛ぶことは不可能
    - 外部連携を制限するには Maintainer 以下にすればよかろう
