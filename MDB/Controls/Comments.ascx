<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Comments.ascx.cs" Inherits="MDB.Controls.Comments" %>
<%@ Import Namespace="Stiig" %>

<div class="comments">
    <asp:ListView ID="lvComments" runat="server" DataSourceID="sdsComments">
        <ItemTemplate>
            <table>
                <tr>
                    <td>
                        <asp:Label ID="lblExecutor" runat="server" CssClass="left" Text='<%# Eval("ExecutorShort") %>' ToolTip='<%# Eval("ExecutorFull") %>'></asp:Label>
                        <asp:Label ID="lblTimeStamp" runat="server" CssClass="right" Text='<%# Utilities.GetFriendlyTime((DateTime)Eval("TimeStamp")) %>'></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblText" runat="server" Text='<%# Eval("Text") %>'></asp:Label>
                    </td>
                </tr>
                <asp:Panel ID="pnlDelete" Visible='<%# MDB.AppCode.Globals.CanUserWrite() || Membership.GetUser().UserName == Eval("Executor").ToString() %>' runat="server">
                    <tr>
                        <td>
                            <asp:LinkButton ID="lnkbtnDelete" CssClass="right" runat="server" OnClientClick="return confirm('Er du sikker på at du vil slette denne kommentar?')" CausesValidation="False" CommandArgument='<%# Eval("Id") %>' OnClick="lnkbtnDelete_Click" Text="Slet"></asp:LinkButton>
                        </td>
                    </tr>
                </asp:Panel>
            </table>
        </ItemTemplate>
    </asp:ListView>
    <asp:DetailsView ID="dvCommentInsert" runat="server" DefaultMode="Insert" AutoGenerateRows="False" DataKeyNames="Id" DataSourceID="sdsComments">
        <Fields>
            <asp:TemplateField ShowHeader="false">
                <InsertItemTemplate>
                    <asp:TextBox ID="txtText" runat="server" placeholder="Kommentar" Text='<%# Bind("Text") %>'></asp:TextBox>
                    <asp:CustomValidator ID="cvText" runat="server" ControlToValidate="txtText" ValidationGroup="Comment" ErrorMessage="Du skal indtaste en kommentar" ValidateEmptyText="true" ClientValidationFunction="ValidateNotEmpty" OnServerValidate="cvText_ServerValidate" />
                    <asp:LinkButton ID="lnkbtnInsert" runat="server" CausesValidation="True" ValidationGroup="Comment" CommandName="Insert" Text="Indsæt"></asp:LinkButton>
                </InsertItemTemplate>
            </asp:TemplateField>
        </Fields>
    </asp:DetailsView>
    <asp:SqlDataSource ID="sdsComments" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        OnSelecting="sdsComments_Selecting" OnInserting="sdsComments_Inserting"
        SelectCommand="SELECT * FROM [CommentsView] WHERE ([ObjectTypeRefId] = @ObjectTypeRefId) AND ([ObjectRefId] = @ObjectRefId) ORDER BY [TimeStamp] ASC"
        InsertCommand="CommentInsert" InsertCommandType="StoredProcedure"
        DeleteCommand="CommentDelete" DeleteCommandType="StoredProcedure">
        <SelectParameters>
            <asp:Parameter Name="ObjectTypeRefId" Type="Int32" />
            <asp:Parameter Name="ObjectRefId" Type="Int32" />
        </SelectParameters>
        <InsertParameters>
            <asp:Parameter Name="ObjectTypeRefId" Type="Int32" />
            <asp:Parameter Name="ObjectRefId" Type="Int32" />
            <asp:Parameter Name="Text" Type="String" />
            <asp:Parameter Name="Executor" Type="String" />
        </InsertParameters>
        <DeleteParameters>
            <asp:Parameter Name="Id" Type="Int32" />
            <asp:Parameter Name="Executor" Type="String" />
        </DeleteParameters>
    </asp:SqlDataSource>
</div>