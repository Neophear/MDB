<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ShowLog.ascx.cs" Inherits="MDB.Controls.ShowLog" %>
<%@ Register Src="~/Controls/DetailsTooltip.ascx" TagPrefix="MDB" TagName="DetailsTooltip" %>

<asp:LinkButton ID="lnkbtnShowLog" runat="server" OnClientClick="showLog(this);return false;">Vis log</asp:LinkButton>
<script type="text/javascript">
    function showLog(sender) {
        sender.style.display = 'none';
        <%= gvLog.ClientID %>.style.display = 'table';
    }
</script>
<asp:GridView ID="gvLog" runat="server" OnRowDataBound="gvLog_RowDataBound" style="display:none;" CssClass="gridview list" AutoGenerateColumns="False" DataSourceID="sdsLog">
    <Columns>
        <asp:BoundField DataField="TimeStamp" DataFormatString="{0:dd-MM-yy HH:mm}" HeaderText="Tidspunkt" SortExpression="TimeStamp" />
        <asp:BoundField DataField="Action" HeaderText="Handling" SortExpression="Action" />
        <asp:BoundField DataField="ObjectType" HeaderText="Type" SortExpression="ObjectType" />
        <asp:BoundField DataField="ObjectId" HeaderText="Id" SortExpression="ObjectId" />
        <asp:TemplateField HeaderText="Properties" SortExpression="Properties">
            <ItemTemplate>
                <asp:Label runat="server" Text='<%# Stiig.Utilities.CutText(Eval("Properties").ToString(), "...", 30, false) %>' ToolTip='<%# Eval("Properties") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Values" SortExpression="Values">
            <ItemTemplate>
                <asp:Label runat="server" Text='<%# Stiig.Utilities.CutText(Eval("Values").ToString(), "...", 60, false) %>'></asp:Label>
                <MDB:DetailsTooltip runat="server" Visible='<%# Eval("Values").ToString().Length > 60 %>' Text='<%# Eval("Values") %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Udfører" SortExpression="Executor">
            <ItemTemplate>
                <asp:Label runat="server" ID="lblExecutor" CssClass="hovertest" Text='<%# Eval("ExecutorShort") %>' />
                <ajaxToolkit:HoverMenuExtender TargetControlID="lblExecutor" PopupControlID="pnlExecutor" OffsetX="-6" OffsetY="-1" runat="server" />
                <asp:Panel ID="pnlExecutor" CssClass="hoverdetails" runat="server">
                    <asp:Label runat="server" Text='<%# Eval("ExecutorFull") %>' />
                </asp:Panel>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>
<asp:SqlDataSource ID="sdsLog" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
    OnSelecting="sdsLog_Selecting"
    SelectCommand="GetObjectLog" SelectCommandType="StoredProcedure">
    <SelectParameters>
        <asp:Parameter Name="ObjectTypeId" ConvertEmptyStringToNull="true" Type="Int32" />
        <asp:Parameter Name="ObjectId" ConvertEmptyStringToNull="true" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>