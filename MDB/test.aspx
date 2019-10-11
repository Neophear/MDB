<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="test.aspx.cs" Inherits="MDB.test" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="Scripts/signature_pad.js"></script>
    <style>
        .wrapper {
          position: relative;
          width: 400px;
          height: 200px;
          -moz-user-select: none;
          -webkit-user-select: none;
          -ms-user-select: none;
          user-select: none;
        }
        img {
          position: absolute;
          left: 0;
          top: 0;
        }

        .signature-pad {
          position: absolute;
          left: 0;
          top: 0;
          width:400px;
          height:200px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div class="wrapper">
          <img src="http://www.licensing.biz/cimages/c0f1a3a97bc0de97271f9813f7715bb3.png" width="400" height="200" />
          <canvas id="signature-pad" class="signature-pad" width="400" height="200"></canvas>
        </div>
        <div>
          <button id="save">Save</button>
          <button id="clear">Clear</button>
        </div>

        <script type="text/javascript">
            var signaturePad = new SignaturePad(document.getElementById('signature-pad'), {
                backgroundColor: 'rgba(255, 255, 255, 0)',
                penColor: 'rgb(0, 0, 0)'
            });
            var saveButton = document.getElementById('save');
            var cancelButton = document.getElementById('clear');

            saveButton.addEventListener('click', function (event) {
                var data = signaturePad.toDataURL('image/png');
                alert(data);
                // Send data to server instead...
            });

            cancelButton.addEventListener('click', function (event) {
                signaturePad.clear();
            });
        </script>
    </div>
    </form>
</body>
</html>
