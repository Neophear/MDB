<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="error.aspx.cs" Inherits="MDB.Public.error" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <div class="error">
        <asp:Label ID="lblErrorMessage" CssClass="error" runat="server" Text="lblErrorMessage"></asp:Label>
    </div>
</asp:Content>
