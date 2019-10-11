<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ReqTextBox.ascx.cs" Inherits="MDB.Controls.ReqTextBox" %>
<asp:TextBox ID="txt" runat="server" />
<asp:RequiredFieldValidator ID="rfv" ControlToValidate="txt" runat="server" />
<asp:RegularExpressionValidator ID="re" ControlToValidate="txt" runat="server" />
<ajaxToolkit:AutoCompleteExtender ID="ace" runat="server" TargetControlID="txt" />