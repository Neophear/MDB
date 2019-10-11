<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="customtable.aspx.cs" Inherits="MDB.customtable" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <asp:Label ID="lblMessage" runat="server" CssClass="error" Text="lblMessage" Visible="false" />
    <div class="customtable">
        <div>
            <asp:ListBox ID="lstbxPresets" runat="server" DataSourceID="sdsPresets" DataValueField="Id" OnSelectedIndexChanged="lstbxPresets_SelectedIndexChanged" DataTextField="Name" AutoPostBack="true" />
            <asp:SqlDataSource ID="sdsPresets" runat="server"
                ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
                SelectCommand="GetSQLPresets" SelectCommandType="StoredProcedure"
                OnSelecting="sdsPresets_Selecting">
                <SelectParameters>
                    <asp:Parameter Name="Role" Type="String" />
                    <asp:Parameter Name="Username" Type="String" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
        <asp:Panel ID="pnlPreset" Visible="false" CssClass="box" runat="server">
            <div>
                <asp:Label ID="lblName" runat="server" Text="lblName" />
            </div>
            <div>
                <asp:Label ID="lblDescription" runat="server" Text="lblDescription"></asp:Label>
            </div>
            <div>
                <asp:Button ID="btnRun" OnClick="btnRun_Click" runat="server" Text="Kør" />
            </div>
            <asp:SqlDataSource ID="sdsPreset" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
                SelectCommand="SELECT * FROM [SQLPresets] WHERE ([Id] = @Id)"
                InsertCommand="SQLPresetInsert" InsertCommandType="StoredProcedure"
                UpdateCommand="SQLPresetUpdate" UpdateCommandType="StoredProcedure"
                DeleteCommand="SQLPresetDelete" DeleteCommandType="StoredProcedure">
                <DeleteParameters>
                    <asp:Parameter Name="Id" Type="Int32" />
                    <asp:Parameter Name="Executor" Type="String" />
                    <asp:Parameter Name="Result" Type="Int16" Direction="Output" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="Value" Type="String" />
                    <asp:Parameter Name="Executor" Type="String" />
                    <asp:Parameter Name="Result" Type="Int16" Direction="Output" />
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="lstbxPresets" Name="Id" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="Value" Type="String" />
                    <asp:Parameter Name="Id" Type="Int32" />
                    <asp:Parameter Name="Executor" Type="String" />
                    <asp:Parameter Name="Result" Type="Int16" Direction="Output" />
                </UpdateParameters>
            </asp:SqlDataSource>
        </asp:Panel>
    </div>
<%--    <div class="left">
        <asp:DetailsView ID="dvPreset" CssClass="detailsview" runat="server" DataSourceID="sdsPreset" AutoGenerateRows="False" DataKeyNames="Id">
            <Fields>
                <asp:BoundField DataField="Id" HeaderText="Id" InsertVisible="False" ReadOnly="True" SortExpression="Id" />
                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                <asp:CheckBoxField DataField="VisibleToRead" HeaderText="VisibleToRead" SortExpression="VisibleToRead" />
                <asp:CheckBoxField DataField="VisibleToWrite" HeaderText="VisibleToWrite" SortExpression="VisibleToWrite" />
                <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" />
            </Fields>
        </asp:DetailsView>
    </div>--%>
    <br />
    <asp:Button ID="btnDownload" runat="server" OnClick="btnDownload_Click" Visible="false" Text="Download CSV" /><br /><br />
    <asp:GridView ID="gvResult" OnDataBound="gvResult_DataBound" AllowSorting="true" OnSorting="gvResult_Sorting" CssClass="gridview list" runat="server"></asp:GridView>
</asp:Content>