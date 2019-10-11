<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="multiemployeeinsert.aspx.cs" Inherits="MDB.multiemployeeinsert" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
<script type="text/javascript">
        var maxLines = <%= maxLines %>;

        $(document).ready(function () {
            RunMultiInsertPageLoad();
        });
    </script>
    <div class="multiInsertTop">
        <div class="infobox">
            <div>
                <img src="/Content/images/icon_info.png" class="icon" />
            </div>
            <div>
                <asp:Label ID="lblMaxLines" runat="server" />
                <asp:Label Text="Brug [PAGEUP] eller [PAGEDOWN] til at fylde en kolonne op eller ned." runat="server" />
                <asp:Label Text="Kun linjer hvor MANR er udfyldt vil blive oprettet." runat="server" />
            </div>
        </div>
        <asp:TextBox runat="server" max='<%# maxLines %>' ID="txtNumberOfRows" CssClass="left" TextMode="Number" />
        <asp:Button Text="Generer linjer" CssClass="left" CausesValidation="false" OnClick="btnGenerateLines_Click" ID="btnGenerateLines" runat="server" />
        <input type="button" value="Fyld alle fra første linje" id="btnFillAll" onclick="FillAll()" class="right" />
    </div>
    <asp:GridView ID="gvUsers" CssClass="gridview" runat="server" OnRowDataBound="gvUsers_RowDataBound" AutoGenerateColumns="False">
        <Columns>
            <asp:TemplateField HeaderText="MANR*">
                <ItemTemplate>
                    <asp:TextBox runat="server" ID="txtMANR" MaxLength="6" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Stabsnummer*">
                <ItemTemplate>
                    <asp:TextBox runat="server" ID="txtStabsnummer" MaxLength="12" />
                    <asp:CustomValidator ID="cvStabsnummer" runat="server" ErrorMessage="Du skal skrive et stabsnummer" ValidateEmptyText="true" ControlToValidate="txtStabsnummer" ClientValidationFunction="ValidateMultiInsertCell" OnServerValidate="cv_ServerValidate" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Navn*">
                <ItemTemplate>
                    <asp:TextBox runat="server" ID="txtName" MaxLength="100" />
                    <asp:CustomValidator ID="cvName" runat="server" ErrorMessage="Du skal skrive et navn" ValidateEmptyText="true" ControlToValidate="txtName" ClientValidationFunction="ValidateMultiInsertCell" OnServerValidate="cv_ServerValidate" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Underskrevet Tro- og love">
                <ItemTemplate>
                    <asp:CheckBox runat="server" ID="chkbxSignedSolemnDeclaration" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Noter">
                <ItemTemplate>
                    <asp:TextBox ID="txtNotes" runat="server"></asp:TextBox>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:Button Text="Opret" ID="btnInsert" OnClick="btnInsert_Click" runat="server" />
    <asp:GridView runat="server" ID="gvResult" CssClass="gridview list" AutoGenerateColumns="false" OnRowDataBound="gvResult_RowDataBound">
        <Columns>
            <asp:BoundField HeaderText="Id" DataField="Id" />
            <asp:BoundField HeaderText="MANR" DataField="MANR" />
            <asp:BoundField HeaderText="Stabsnummer" DataField="Stabsnummer" />
            <asp:BoundField HeaderText="Navn" DataField="Name" />
            <asp:BoundField HeaderText="Underskrevet Tro- og love" DataField="SignedSolemnDeclaration" />
            <asp:BoundField HeaderText="Noter" DataField="Notes" />
        </Columns>
    </asp:GridView>
</asp:Content>