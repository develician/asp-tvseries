<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Inherits="tvSeries.HomePage" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" runat="server" href="/Styles/Admin/PostManagement.css" />
    <script runat="server">
        int currentPage = 1;
        PagedDataSource pagedDataSource;
        protected void Page_Load(object sender, EventArgs e)
        {


            if (Request.QueryString["page"] != null)
            {
                currentPage = Int32.Parse(Request.QueryString["page"].ToString());
            }
            else
            {
                currentPage = 1;
            }



            if (!Page.IsPostBack)
            {
                GetPostList(currentPage);
                PageLabel.Text = "Page " + currentPage;
            }
        }

        protected void GetPostList(int currentPage)
        {
            SqlConnection conn =
                new SqlConnection("Data Source=.\\SQLEXPRESS; Initial Catalog=MyDB; Integrated Security=False; uid=killi8n; pwd=admin1234");
            String SQL = "SELECT * FROM tvseries.dbo.Series ORDER BY id DESC";
            SqlCommand command = new SqlCommand(SQL, conn);

            try
            {
                conn.Open();

                DataSet dataSet = new DataSet();

                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(SQL, conn);
                sqlDataAdapter.Fill(dataSet);

                pagedDataSource = new PagedDataSource();
                pagedDataSource.AllowPaging = true;
                pagedDataSource.DataSource = dataSet.Tables[0].DefaultView;
                pagedDataSource.PageSize = 10;
                pagedDataSource.CurrentPageIndex = currentPage - 1;


                PostDataList.DataSource = pagedDataSource;
                PostDataList.DataBind();




            }
            catch (Exception exception)
            {
                Response.Write(exception.Message.ToString());
            }
            finally
            {
                conn.Close();
            }

        }

        protected void NextPageAction(object sender, EventArgs e)
        {
            int urlPage = currentPage + 1;

            GetPostList(currentPage);

            if (pagedDataSource.IsLastPage)
            {
                Response.Redirect("/HomePage.aspx?page=" + (currentPage));
                return;
            }


            Response.Redirect("/HomePage.aspx?page=" + urlPage);
        }

        protected void PrevPageAction(object sender, EventArgs e)
        {
            int urlPage = currentPage - 1;

            GetPostList(currentPage);

            if (pagedDataSource.IsFirstPage)
            {
                Response.Redirect("/HomePage.aspx?page=" + (currentPage));
                return;
            }
            Response.Redirect("/HomePage.aspx?page=" + urlPage);
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="PostManagementForm">
        <asp:DataList CssClass="PostDataList" runat="server" ID="PostDataList" RepeatDirection="Vertical">
            <ItemTemplate>
                <div class="PostItem">
                    <div class="Left">
                        <a href="/Series/PostDetail.aspx?id=<%# Eval("id") %>">
                            <img src="/Uploads/<%# Eval("trailerImage").ToString().Split(',')[0] %>" />
                        </a>
                    </div>
                    <div class="Right">

                        <div class="Title">
                            <a href="/Series/PostDetail.aspx?id=<%# Eval("id") %>">
                                <%# Eval("title") %>
                            </a>
                        </div>
                        <div class="Genre">
                            <a href="/Series/PostDetail.aspx?id=<%# Eval("id") %>">
                                <%# Eval("genre") %>
                            </a>
                        </div>
                        <div class="Year">
                            <a href="/Series/PostDetail.aspx?id=<%# Eval("id") %>">
                                <%# Eval("year") %>
                            </a>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:DataList>

    </div>
    <div class="Pagination">
        <asp:Button runat="server" ID="PrevButton" CssClass="Button" Text="Prev" OnClick="PrevPageAction" />
        <asp:Label runat="server" ID="PageLabel" CssClass="PageLabel" Text="Page 1"></asp:Label>
        <asp:Button runat="server" ID="Button1" CssClass="Button" Text="Next" OnClick="NextPageAction" />
    </div>
</asp:Content>
