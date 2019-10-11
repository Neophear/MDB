<%@ Page Title="Log ind" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="MDB.Public.login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <asp:Login ID="Login1" CssClass="loginbox centered" runat="server" OnLoginError="Login1_LoginError">
        <LayoutTemplate>
            <table>
                <tr>
                    <td colspan="2">
                        <h2>Log ind</h2>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">Brugernavn:</asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="UserName" runat="server"></asp:TextBox>
                    </td>
                    <td>
                        <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" ErrorMessage="Brugernavn er påkrævet." ToolTip="Brugernavn er påkrævet." ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">Password:</asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="Password" runat="server" TextMode="Password"></asp:TextBox>
                    </td>
                    <td>
                        <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password" ErrorMessage="Password er påkrævet." ToolTip="Password er påkrævet." ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:CheckBox ID="RememberMe" runat="server" Text="Husk mig." />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="color:Red;">
                        <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Button ID="LoginButton" runat="server" CommandName="Login" Text="Log ind" ValidationGroup="Login1" />
                    </td>
                </tr>
            </table>
        </LayoutTemplate>
    </asp:Login>
</asp:Content>