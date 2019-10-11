<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="MDB.admin._default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <div class="centered">
        Adminmenu<br />
        <asp:HyperLink ID="hplUsers" NavigateUrl="~/admin/users.aspx" runat="server">Brugere på siden</asp:HyperLink><br />
    </div>
</asp:Content>