// DOM読み込みが完了したら実行
document.addEventListener('DOMContentLoaded', (e) => {
  // payjp.jsの初期化
  Payjp.setPublicKey('pk_test_932adb5c9baabfd8d99fadb3');
  
  // ボタンのイベントハンドリング
  const btn = document.getElementById('token');
  btn.addEventListener('click', (e) => {
    e.preventDefault();
    
    // カード情報生成
    const card = {
      number: document.getElementById('card_number').value,
      cvc: document.getElementById('cvv').value,
      exp_month: document.getElementById('exp_month').value,
      exp_year: document.getElementById('exp_year').value
    };
    
    // トークン生成
    Payjp.createToken(card, (status, response) => {
      if (status === 200) {
        // 出力（本来はサーバへ送信）
        document.getElementById('card_token').innerHTML = response.card.id;
      }
    });
  });
}, false);