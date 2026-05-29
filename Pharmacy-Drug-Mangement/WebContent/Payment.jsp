<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Payment</title>
<link rel="stylesheet" href="css/Buy.css">
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { font-family: 'Segoe UI', sans-serif; background: #f4f4f4; }

  .pay-container {
    max-width: 480px; margin: 60px auto; background: white;
    border-radius: 14px; box-shadow: 0 4px 24px rgba(0,0,0,0.13);
    padding: 36px 30px; text-align: center;
  }

  .pay-container h2 { color: #0ca1a6; margin-bottom: 6px; font-size: 22px; }
  .pay-container > p { color: #555; font-size: 14px; margin-bottom: 18px; }

  /* Order Info Box */
  .order-info {
    background: #f0fbfb; border-radius: 10px;
    padding: 16px; margin-bottom: 24px; font-size: 15px;
  }
  .order-info p { margin: 5px 0; color: #444; }
  .amount-badge { font-size: 34px; font-weight: 800; color: #0ca1a6; margin: 10px 0; }
  .success-note { font-size: 12px; color: #888; margin-top: 6px; }

  /* UPI Buttons */
  .upi-buttons { display: flex; flex-direction: column; gap: 12px; }

  .upi-btn {
    display: flex; align-items: center; justify-content: space-between;
    padding: 14px 20px; border-radius: 10px; font-size: 16px; font-weight: 700;
    text-decoration: none; color: white; cursor: pointer; border: none;
    transition: opacity 0.18s, transform 0.15s;
    box-shadow: 0 3px 10px rgba(0,0,0,0.15);
  }
  .upi-btn:hover { opacity: 0.9; transform: translateY(-2px); }
  .upi-btn:active { transform: translateY(0); opacity: 1; }

  .btn-left  { display: flex; align-items: center; gap: 10px; }
  .btn-icon  { font-size: 22px; width: 28px; text-align: center; }
  .btn-amount { background: rgba(255,255,255,0.22); border-radius: 20px; padding: 3px 11px; font-size: 14px; font-weight: 700; }

  /* Individual app colours */
  .gpay    { background: linear-gradient(135deg, #4285F4 0%, #34A853 100%); }
  .phonepe { background: linear-gradient(135deg, #5f259f 0%, #8b2fc9 100%); }
  .paytm   { background: linear-gradient(135deg, #00B9F1 0%, #0077B6 100%); }
  .anyupi  { background: linear-gradient(135deg, #ff6b35 0%, #f7464a 100%); }

  /* Skip */
  .skip-btn {
    display: inline-block; margin-top: 20px;
    color: #777; font-size: 13px; text-decoration: underline; cursor: pointer;
  }
  .skip-btn:hover { color: #333; }

  /* ── Bottom Sheet Overlay ── */
  .overlay {
    display: none; position: fixed; inset: 0;
    background: rgba(0,0,0,0.5); z-index: 999;
    align-items: flex-end; justify-content: center;
  }
  .overlay.active { display: flex; }

  .sheet {
    background: #fff; border-radius: 20px 20px 0 0;
    width: 100%; max-width: 480px;
    padding: 24px 28px 36px;
    text-align: center;
    animation: slideUp 0.28s ease;
  }
  @keyframes slideUp { from { transform: translateY(100%); } to { transform: translateY(0); } }

  .sheet-handle { width: 38px; height: 4px; background: #ddd; border-radius: 4px; margin: 0 auto 18px; }

  .sheet-app-icon { font-size: 40px; margin-bottom: 4px; }
  .sheet-app-name { font-size: 18px; font-weight: 800; margin-bottom: 2px; }
  .sheet-app-sub  { font-size: 12px; color: #888; margin-bottom: 18px; }

  /* Amount in sheet */
  .sheet-amount-box {
    border-radius: 12px; padding: 16px; margin-bottom: 20px;
    border: 2px solid;
  }
  .sheet-amount-label { font-size: 12px; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 4px; }
  .sheet-amount-val   { font-size: 44px; font-weight: 900; line-height: 1.1; }
  .sheet-amount-val sup { font-size: 22px; }
  .sheet-order-info   { font-size: 12px; color: #777; margin-top: 8px; }

  /* Pay Now button inside sheet */
  .sheet-pay-btn {
    width: 100%; padding: 15px; border: none; border-radius: 10px;
    font-size: 17px; font-weight: 800; color: white; cursor: pointer;
    box-shadow: 0 4px 14px rgba(0,0,0,0.2);
    transition: opacity 0.2s, transform 0.15s;
  }
  .sheet-pay-btn:hover { opacity: 0.9; transform: translateY(-1px); }

  .sheet-skip { display: block; margin-top: 14px; font-size: 13px; color: #999; text-decoration: underline; cursor: pointer; border: none; background: none; width: 100%; }
  .sheet-skip:hover { color: #444; }
  .sheet-secure { font-size: 11px; color: #bbb; margin-top: 12px; }
</style>
</head>
<body>
<%
  String amountStr = request.getParameter("amount");
  String prodId    = request.getParameter("pid");
  String qty       = request.getParameter("qty");
  int amount = 0;
  try { amount = Integer.parseInt(amountStr); } catch(Exception e){}

  // ================================================================
  // CHANGE THIS to your pharmacy's actual registered UPI ID
  String upiId   = "pharmacy@upi";
  String upiName = "DrMSS Pharmacy";
  // ================================================================

  String enc     = java.net.URLEncoder.encode(upiName, "UTF-8");
  String tn      = java.net.URLEncoder.encode("Order " + prodId + " Qty " + qty, "UTF-8");

  // Each app's official deep-link scheme
  String gPayLink    = "tez://upi/pay?pa="      + upiId + "&pn=" + enc + "&am=" + amount + "&cu=INR&tn=" + tn;
  String phonePeLink = "phonepe://pay?pa="       + upiId + "&pn=" + enc + "&am=" + amount + "&cu=INR&tn=" + tn;
  String paytmLink   = "paytmmp://pay?pa="       + upiId + "&pn=" + enc + "&am=" + amount + "&cu=INR&tn=" + tn;
  String anyUpiLink  = "upi://pay?pa="           + upiId + "&pn=" + enc + "&am=" + amount + "&cu=INR&tn=" + tn;

  // Android intent fallbacks (by package name)
  String gPayIntent    = "intent://upi/pay?pa=" + upiId + "&pn=" + enc + "&am=" + amount + "&cu=INR&tn=" + tn + "#Intent;scheme=tez;package=com.google.android.apps.nbu.paisa.user;end";
  String phonePeIntent = "intent://pay?pa="     + upiId + "&pn=" + enc + "&am=" + amount + "&cu=INR&tn=" + tn + "#Intent;scheme=phonepe;package=com.phonepe.app;end";
  String paytmIntent   = "intent://pay?pa="     + upiId + "&pn=" + enc + "&am=" + amount + "&cu=INR&tn=" + tn + "#Intent;scheme=paytmmp;package=net.one97.paytm;end";
  String anyUpiIntent  = "intent://pay?pa="     + upiId + "&pn=" + enc + "&am=" + amount + "&cu=INR&tn=" + tn + "#Intent;scheme=upi;package=org.npci.upiapp;end";
%>

<!-- ══════════ MAIN PAYMENT PAGE ══════════ -->
<div class="pay-container">
  <h2>&#128138; Complete Your Payment</h2>
  <p>Your order has been placed! Pay securely via UPI.</p>

  <div class="order-info">
    <p><b>Product:</b> <%=prodId%></p>
    <p><b>Quantity:</b> <%=qty%></p>
    <div class="amount-badge">&#8377;<%=amount%></div>
    <p class="success-note">&#10003; Order saved. Payment completes your transaction.</p>
  </div>

  <div class="upi-buttons">

    <!-- Google Pay -->
    <a class="upi-btn gpay" href="#"
       onclick="openSheet('gpay'); return false;">
      <div class="btn-left">
        <span class="btn-icon">G</span>
        Pay with Google Pay
      </div>
      <span class="btn-amount">&#8377;<%=amount%></span>
    </a>

    <!-- PhonePe -->
    <a class="upi-btn phonepe" href="#"
       onclick="openSheet('phonepe'); return false;">
      <div class="btn-left">
        <span class="btn-icon">&#9654;</span>
        Pay with PhonePe
      </div>
      <span class="btn-amount">&#8377;<%=amount%></span>
    </a>

    <!-- Paytm -->
    <a class="upi-btn paytm" href="#"
       onclick="openSheet('paytm'); return false;">
      <div class="btn-left">
        <span class="btn-icon">P</span>
        Pay with Paytm
      </div>
      <span class="btn-amount">&#8377;<%=amount%></span>
    </a>

    <!-- Any UPI -->
    <a class="upi-btn anyupi" href="#"
       onclick="openSheet('anyupi'); return false;">
      <div class="btn-left">
        <span class="btn-icon">&#128241;</span>
        Open Any UPI App
      </div>
      <span class="btn-amount">&#8377;<%=amount%></span>
    </a>

  </div>

  <a class="skip-btn" href="Orders.jsp">Skip Payment &#8594; View My Orders</a>
</div>


<!-- ══════════ BOTTOM SHEET (Meesho-style) ══════════ -->
<div class="overlay" id="overlay" onclick="closeBg(event)">
  <div class="sheet" id="sheet">
    <div class="sheet-handle"></div>

    <div class="sheet-app-icon"  id="sheetIcon"></div>
    <div class="sheet-app-name"  id="sheetName"></div>
    <div class="sheet-app-sub"   id="sheetSub"></div>

    <div class="sheet-amount-box" id="sheetAmtBox">
      <div class="sheet-amount-label" id="sheetAmtLabel">Amount to Pay</div>
      <div class="sheet-amount-val"><sup>&#8377;</sup><%=amount%></div>
      <div class="sheet-order-info">Product: <%=prodId%> &nbsp;|&nbsp; Qty: <%=qty%></div>
    </div>

    <button class="sheet-pay-btn" id="sheetPayBtn" onclick="launchApp()">
      Pay Now  &#8377;<%=amount%>
    </button>

    <button class="sheet-skip" onclick="window.location.href='Orders.jsp'">
      Skip Payment &#8594; View My Orders
    </button>

    <div class="sheet-secure">&#128274; Secured by UPI &bull; 256-bit encrypted</div>
  </div>
</div>


<script>
  // Deep links passed from JSP
  var links = {
    gpay:    { deep: '<%=gPayLink%>',    intent: '<%=gPayIntent%>' },
    phonepe: { deep: '<%=phonePeLink%>', intent: '<%=phonePeIntent%>' },
    paytm:   { deep: '<%=paytmLink%>',  intent: '<%=paytmIntent%>' },
    anyupi:  { deep: '<%=anyUpiLink%>',  intent: '<%=anyUpiIntent%>' }
  };

  // App display config
  var apps = {
    gpay:    { icon: '🅖',  name: 'Google Pay',   sub: 'Pay securely with Google Pay UPI',  color: '#4285F4', btnBg: 'linear-gradient(135deg,#4285F4,#34A853)', amtBorder: '#4285F4', amtBg: '#e8f0fe', labelColor: '#1a73e8', valColor: '#0d47a1' },
    phonepe: { icon: '💜',  name: 'PhonePe',      sub: 'Pay securely with PhonePe UPI',     color: '#5f259f', btnBg: 'linear-gradient(135deg,#5f259f,#8b2fc9)', amtBorder: '#7b1fa2', amtBg: '#f3e5f5', labelColor: '#6a1b9a', valColor: '#4a148c' },
    paytm:   { icon: '🔵',  name: 'Paytm',        sub: 'Pay securely with Paytm UPI',       color: '#00B9F1', btnBg: 'linear-gradient(135deg,#00B9F1,#0077B6)', amtBorder: '#0077B6', amtBg: '#e1f5fe', labelColor: '#0288d1', valColor: '#01579b' },
    anyupi:  { icon: '📱',  name: 'UPI Payment',  sub: 'Opens your default UPI app',        color: '#ff6b35', btnBg: 'linear-gradient(135deg,#ff6b35,#f7464a)', amtBorder: '#ff6b35', amtBg: '#fff3e0', labelColor: '#e65100', valColor: '#bf360c' }
  };

  var currentApp = null;

  function openSheet(appKey) {
    currentApp = appKey;
    var a = apps[appKey];

    document.getElementById('sheetIcon').textContent    = a.icon;
    document.getElementById('sheetName').textContent    = a.name;
    document.getElementById('sheetSub').textContent     = a.sub;

    var box = document.getElementById('sheetAmtBox');
    box.style.background    = a.amtBg;
    box.style.borderColor   = a.amtBorder;

    document.getElementById('sheetAmtLabel').style.color = a.labelColor;
    document.querySelector('.sheet-amount-val').style.color = a.valColor;

    var btn = document.getElementById('sheetPayBtn');
    btn.style.background = a.btnBg;

    document.getElementById('overlay').classList.add('active');
  }

  function closeBg(e) {
    if (e.target === document.getElementById('overlay')) {
      document.getElementById('overlay').classList.remove('active');
    }
  }

  function launchApp() {
    if (!currentApp) return;
    var ua        = navigator.userAgent;
    var isAndroid = /android/i.test(ua);
    var isIOS     = /iphone|ipad|ipod/i.test(ua);
    var l         = links[currentApp];

    if (isAndroid) {
      // Try the app's own scheme first
      window.location.href = l.deep;
      // Fallback via intent:// after 1.5s if app not installed
      setTimeout(function() { window.location.href = l.intent; }, 1500);
    } else if (isIOS) {
      window.location.href = l.deep;
    } else {
      // Desktop — inform user
      alert(apps[currentApp].name + ' is a mobile app.\nPlease open this page on your phone to pay \u20B9<%=amount%>.');
    }
  }
</script>
</body>
</html>
