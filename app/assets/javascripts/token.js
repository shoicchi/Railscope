

$(function(){
  $(document).on('click','(登録ボタンのIDやクラス名)', function(e) {
    e.preventDefault();
    Payjp.setPublicKey('（Pay.jpに登録した時に取得できる公開鍵）');
    var card = {
      number: parseInt($("（カード番号入力欄のIDやクラス名）").val()),
      cvc: parseInt($("（セキュリティーコード入力欄のIDやクラス名）").val()),
      exp_month: parseInt($("（有効月入力欄のIDやクラス名）").val()),
      exp_year: parseInt($("（有効年入力欄のIDやクラス名）").val())
    };
    Payjp.createToken(card, function(status, response) {
      if (status == 200) {
        var token = response.id;
        $.ajax({
          url: （動かしたいコントローラーのメソッドのurl）,
          type: "POST",
          data: { token: token },
          dataType: 'json',
        })
        .done(function(){
          //非同期通信失敗時の処理
        })
        .fail(function(){
          //非同期通信失敗時の処理
        })
      }
      else {
        //トークン作成失敗時の処理
      }
    });
  })
})