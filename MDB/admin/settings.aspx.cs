using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MDB.admin
{
    public partial class settings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblUnitMessage.Visible = false;
            lblChangeSolemnDeclarationMessage.Visible = false;
            lblDataPlanMessage.Visible = false;
        }

        protected void btnChangeSolemnDeclaration_Click(object sender, EventArgs e)
        {
            if (fuChangeSolemnDeclaration.HasFile)
            {
                string ext = Path.GetExtension(fuChangeSolemnDeclaration.FileName);

                if (ext.ToLower() != ".docx")
                    SetMessage(MessagePart.SignedSolemnDeclaration, "Filen er ikke en docx-fil", true);
                else if (fuChangeSolemnDeclaration.FileContent.Length > 2000000)
                    SetMessage(MessagePart.SignedSolemnDeclaration, "Filen er over 2MB", true);
                else
                {
                    string filePath = Server.MapPath("~/Files/") + "solemndeclaration.docx";
                    fuChangeSolemnDeclaration.SaveAs(filePath);
                    SetMessage(MessagePart.SignedSolemnDeclaration, "Dokument uploadet");
                }
            }
            else
                SetMessage(MessagePart.SignedSolemnDeclaration, "Kunne ikke finde filen", true);
        }

        protected void sds_Changing(object sender, SqlDataSourceCommandEventArgs e)
        {
            e.Command.Parameters["@Executor"].Value = User.Identity.Name;
        }
        protected void sdsUnit_Changed(object sender, SqlDataSourceStatusEventArgs e)
        {
            short result = (short)e.Command.Parameters["@Result"].Value;
            switch (result)
            {
                case 1:
                    SetMessage(MessagePart.Unit, "Forkortelsen findes i forvejen");
                    break;
                case 2:
                    SetMessage(MessagePart.Unit, "Der findes mobile enheder eller simkort der er tilknyttet enheden");
                    break;
                default:
                    dvUnit.ChangeMode(DetailsViewMode.Insert);
                    gvUnits.DataBind();
                    break;
            }
        }

        protected void sdsDataPlan_Changed(object sender, SqlDataSourceStatusEventArgs e)
        {
            short result = (short)e.Command.Parameters["@Result"].Value;
            switch (result)
            {
                case 1:
                    SetMessage(MessagePart.DataPlan, "Navnet findes i forvejen");
                    break;
                case 2:
                    SetMessage(MessagePart.DataPlan, "Der findes simkort med denne dataplan");
                    break;
                default:
                    dvDataPlan.ChangeMode(DetailsViewMode.Insert);
                    gvDataPlans.DataBind();
                    break;
            }
        }

        void SetMessage(MessagePart mp, string m, bool e = true)
        {
            Label l = null;

            switch (mp)
            {
                case MessagePart.Unit:
                    l = lblUnitMessage;
                    break;
                case MessagePart.SignedSolemnDeclaration:
                    l = lblChangeSolemnDeclarationMessage;
                    break;
                case MessagePart.DataPlan:
                    l = lblDataPlanMessage;
                    break;
            }

            l.Text = m;
            l.CssClass = e ? "error" : "";
            l.Visible = true;
        }

        protected void gvUnits_SelectedIndexChanged(object sender, EventArgs e)
        {
            dvUnit.ChangeMode(DetailsViewMode.Edit);
        }

        protected void gvDataPlans_SelectedIndexChanged(object sender, EventArgs e)
        {
            dvDataPlan.ChangeMode(DetailsViewMode.Edit);
        }

        enum MessagePart
        {
            Unit,
            SignedSolemnDeclaration,
            DataPlan
        }
    }
}