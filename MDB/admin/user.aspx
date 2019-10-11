<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="user.aspx.cs" Inherits="MDB.admin.user" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <asp:Label ID="lblMsg" runat="server" Visible="false" Text="lblMsg"></asp:Label>
    <asp:Table ID="tblUser" runat="server">
        <asp:TableRow>
            <asp:TableCell>
                <asp:Label ID="lblUsername" runat="server" AssociatedControlID="txtUsername">MANR:</asp:Label>
            </asp:TableCell>
            <asp:TableCell>
                <asp:TextBox ID="txtUsername" runat="server" ReadOnly="true" MaxLength="50"></asp:TextBox>
            </asp:TableCell>
            <asp:TableCell>
                <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername" ErrorMessage="MANR er påkrævet." ToolTip="MANR er påkrævet."></asp:RequiredFieldValidator>
            </asp:TableCell>
        </asp:TableRow>
        <asp:TableRow>
            <asp:TableCell>
                <asp:Label ID="lblFirstname" runat="server" AssociatedControlID="txtFirstname">Fornavn(e):</asp:Label>
            </asp:TableCell>
            <asp:TableCell>
                <asp:TextBox ID="txtFirstname" runat="server" MaxLength="100"></asp:TextBox>
            </asp:TableCell>
            <asp:TableCell>
                <asp:RequiredFieldValidator ID="rfvFirstname" runat="server" ControlToValidate="txtFirstname" ErrorMessage="Fornavn er påkrævet." ToolTip="Fornavn er påkrævet."></asp:RequiredFieldValidator>
            </asp:TableCell>
        </asp:TableRow>
        <asp:TableRow>
            <asp:TableCell>
                <asp:Label ID="lblLastname" runat="server" AssociatedControlID="txtLastname">Efternavn:</asp:Label>
            </asp:TableCell>
            <asp:TableCell>
                <asp:TextBox ID="txtLastname" runat="server" MaxLength="50"></asp:TextBox>
            </asp:TableCell>
            <asp:TableCell>
                <asp:RequiredFieldValidator ID="rfvLastname" runat="server" ControlToValidate="txtLastname" ErrorMessage="Efternavn er påkrævet." ToolTip="Efternavn er påkrævet."></asp:RequiredFieldValidator>
            </asp:TableCell>
        </asp:TableRow>
        <asp:TableRow>
            <asp:TableCell>
                <asp:Label ID="lblType" runat="server" AssociatedControlID="ddlType" Text="Type:"></asp:Label>
            </asp:TableCell>
            <asp:TableCell>
                <asp:DropDownList ID="ddlType" runat="server">
                    <asp:ListItem Value="0">Read</asp:ListItem>
                    <asp:ListItem Value="1">Write</asp:ListItem>
                    <asp:ListItem Value="2">Admin</asp:ListItem>
                </asp:DropDownList>
            </asp:TableCell>
        </asp:TableRow>
        <asp:TableRow ID="trEnabled" Visible="false">
            <asp:TableCell>
                <asp:Label ID="lblEnabled" runat="server" AssociatedControlID="chkbxEnabled" Text="Aktiv:"></asp:Label>
            </asp:TableCell>
            <asp:TableCell>
                <asp:CheckBox ID="chkbxEnabled" Checked="true" runat="server" />
            </asp:TableCell>
        </asp:TableRow>
        <asp:TableRow ID="trLocked" Visible="false">
            <asp:TableCell>
                <asp:Label ID="lblLocked" runat="server" AssociatedControlID="chkbxLocked" Text="Låst:"></asp:Label>
            </asp:TableCell>
            <asp:TableCell>
                <asp:CheckBox ID="chkbxLocked" Checked="true" Text="Lås op" runat="server" />
                <asp:Label ID="lblNotLocked" runat="server" Text="Ikke låst"></asp:Label>
            </asp:TableCell>
        </asp:TableRow>
        <asp:TableRow ID="trResetPassword" Visible="false">
            <asp:TableCell>
                <asp:Label ID="lblResetPassword" runat="server" AssociatedControlID="chkbxResetPassword" Text="Nulstil password:"></asp:Label>
            </asp:TableCell>
            <asp:TableCell>
                <asp:CheckBox ID="chkbxResetPassword" Checked="false" Text="Nulstil" runat="server" />
            </asp:TableCell>
        </asp:TableRow>
        <asp:TableRow>
            <asp:TableCell ColumnSpan="2">
                <asp:Button ID="btnCreateUser" runat="server" Text="Opret" OnClick="btnCreateUser_Click" />
                <asp:Button ID="btnUpdateUser" runat="server" Visible="false" Text="Opdater" OnClick="btnUpdateUser_Click" />
                <asp:Button ID="btnDeleteUser" Enabled="true" CausesValidation="false" runat="server" Visible="false" ToolTip="Ikke implementeret" Text="Slet" OnClick="btnDeleteUser_Click" OnClientClick="return confirm('Er du sikker på at du vil slette denne bruger?')" />
            </asp:TableCell>
            <asp:TableCell></asp:TableCell>
        </asp:TableRow>
    </asp:Table>
</asp:Content>