<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="news.aspx.cs" Inherits="MDB.admin.news" %>
<%@ Register Src="~/Controls/AdvancedTextbox.ascx" TagPrefix="mdb" TagName="AdvancedTextbox" %>
<%@ Import Namespace="Stiig" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <asp:Panel ID="pnlShow" Visible="true" runat="server">
        <table class='news <%= Sticky ? "newsSticky" : "newsNormal" %>'>
            <tr>
                <td class="newsTitle">
                    <asp:Label ID="lblTitle" CssClass="left" runat="server"></asp:Label>
                    <asp:Label ID="lblTimeStamp" CssClass="right" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="newsContent">
                    <asp:Label ID="lblContent" runat="server"></asp:Label>
                </td>
            </tr>
        </table>
        <br />
        <br />
    </asp:Panel>
    <asp:DetailsView ID="dvNews" CssClass="newsEditor" runat="server" AutoGenerateRows="False" DataKeyNames="ID" DataSourceID="sdsNews"
        OnDataBound="dvNews_DataBound" OnItemUpdating="dvNews_ItemUpdating" OnItemInserting="dvNews_ItemInserting">
        <Fields>
            <asp:TemplateField HeaderText="Titel" SortExpression="Title">
                <EditItemTemplate>
                    <asp:TextBox ID="txtTitle" runat="server" Text='<%# Bind("Title") %>' MaxLength="50"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ErrorMessage="Du skal udfylde en titel" ControlToValidate="txtTitle"></asp:RequiredFieldValidator>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="txtTitle" runat="server" Text='<%# Bind("Title") %>' MaxLength="50"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ErrorMessage="Du skal udfylde en titel" ControlToValidate="txtTitle"></asp:RequiredFieldValidator>
                </InsertItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Indhold" SortExpression="Content">
                <EditItemTemplate>
                    <mdb:AdvancedTextbox runat="server" Text='<%# Bind("Content") %>' Width="600" ID="advtxtContent" />
                    <asp:RequiredFieldValidator ID="rfvContent" runat="server" ErrorMessage="Du skal udfylde en tekst" ControlToValidate="advtxtContent:txtText"></asp:RequiredFieldValidator>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <mdb:AdvancedTextbox runat="server" Text='<%# Bind("Content") %>' Width="600" ID="advtxtContent" />
                    <asp:RequiredFieldValidator ID="rfvContent" runat="server" ErrorMessage="Du skal udfylde en tekst" ControlToValidate="advtxtContent:txtText"></asp:RequiredFieldValidator>
                </InsertItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Synlighed">
                <EditItemTemplate>
                    <asp:CheckBox ID="chkbxVisibleToRead" Checked='<%# Bind("VisibleToRead") %>' Text="Kan ses af Read" runat="server" />
                    <asp:CheckBox ID="chkbxVisibleToWrite" Checked='<%# Bind("VisibleToWrite") %>' Text="Kan ses af Write" runat="server" />
                    <asp:CheckBox ID="chkbxSticky" Checked='<%# Bind("Sticky") %>' Text="Sticky" runat="server" />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:CheckBox ID="chkbxVisibleToRead" Checked='<%# Bind("VisibleToRead") %>' Text="Kan ses af Read" runat="server" />
                    <asp:CheckBox ID="chkbxVisibleToWrite" Checked='<%# Bind("VisibleToWrite") %>' Text="Kan ses af Write" runat="server" />
                    <asp:CheckBox ID="chkbxSticky" Checked='<%# Bind("Sticky") %>' Text="Sticky" runat="server" />
                </InsertItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ShowHeader="False">
                <EditItemTemplate>
                    <asp:LinkButton ID="lnkbtnShowExample" runat="server" CausesValidation="True" OnClick="lnkbtnShowExample_Click" Text="Vis eksempel" />
                    <asp:LinkButton ID="lnkbtnUpdate" runat="server" CausesValidation="True" CommandName="Update" Text="Gem" />
                    &nbsp;<asp:LinkButton ID="lnkbtnCancel" runat="server" CausesValidation="False" CommandName="Cancel" Text="Annuller" />
                    &nbsp;<asp:LinkButton ID="lnkbtnDelete" runat="server" CausesValidation="False" CommandName="Delete" Text="Slet" OnClientClick="return confirm('Er du sikker på at du vil slette denne nyhed?')"></asp:LinkButton>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:LinkButton ID="lnkbtnShowExample" runat="server" CausesValidation="True" OnClick="lnkbtnShowExample_Click" Text="Vis eksempel" />
                    &nbsp;<asp:LinkButton ID="lnkbtnCreate" runat="server" CausesValidation="True" CommandName="Insert" Text="Opret" />
                    &nbsp;<asp:LinkButton ID="lnkbtnCancel" runat="server" CausesValidation="False" CommandName="Cancel" Text="Annuller" />
                </InsertItemTemplate>
            </asp:TemplateField>
        </Fields>
    </asp:DetailsView>
    <asp:SqlDataSource ID="sdsNews" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        OnSelecting="sdsNews_Selecting"
        OnSelected="sdsNews_Selected"
        OnDeleted="sdsNews_Deleted"
        OnUpdated="sdsNews_Updated"
        OnInserted="sdsNews_Inserted"
        OnInserting="sdsNews_Changing" OnUpdating="sdsNews_Changing" OnDeleting="sdsNews_Changing"
        SelectCommand="SELECT * FROM [News] WHERE [ID] = @ID"
        DeleteCommand="NewsDelete" DeleteCommandType="StoredProcedure"
        InsertCommand="NewsInsert" InsertCommandType="StoredProcedure"
        UpdateCommand="NewsUpdate" UpdateCommandType="StoredProcedure">
        <DeleteParameters>
            <asp:Parameter Name="Id" Type="Int32" />
            <asp:Parameter Name="Executor" Type="String" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="Title" Type="String" />
            <asp:Parameter Name="Content" Type="String" />
            <asp:Parameter Name="VisibleToRead" Type="Boolean" />
            <asp:Parameter Name="VisibleToWrite" Type="Boolean" />
            <asp:Parameter Name="Sticky" Type="Boolean" />
            <asp:Parameter Name="Executor" Type="String" />
            <asp:Parameter Name="LastId" Type="Int32" Direction="Output" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="Id" Type="Int32" />
            <asp:Parameter Name="Title" Type="String" />
            <asp:Parameter Name="Content" Type="String" />
            <asp:Parameter Name="VisibleToRead" Type="Boolean" />
            <asp:Parameter Name="VisibleToWrite" Type="Boolean" />
            <asp:Parameter Name="Sticky" Type="Boolean" />
            <asp:Parameter Name="Executor" Type="String" />
        </UpdateParameters>
        <SelectParameters>
            <asp:Parameter Name="Id" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>