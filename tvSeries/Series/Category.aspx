<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Category.aspx.cs" Inherits="tvSeries.Series.Category" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" runat="server" href="/Styles/Admin/PostManagement.css" />
    <script runat="server">
        int currentPage = 1;
        PagedDataSource pagedDataSource;
        protected void Page_Load(object sender, EventArgs e)
        {


            if (Request.QueryString["page"] != null && Request.QueryString["genre"] != null)
            {
                currentPage = Int32.Parse(Request.QueryString["page"].ToString());
            }
            else
            {
                currentPage = 1;
            }

            if (!Page.IsPostBack)
            {
                GetSeriesByGenre(Request.QueryString["genre"], currentPage);
                PageLabel.Text = "Page " + currentPage;
            }

        }

        protected void GetSeriesByGenre(string genre, int currentPage)
        {
            SqlConnection conn =
                new SqlConnection("Data Source=.\\SQLEXPRESS; Initial Catalog=MyDB; Integrated Security=False; uid=killi8n; pwd=admin1234");
            String SQL = "SELECT * FROM tvseries.dbo.Series WHERE genre LIKE '%" + Request.QueryString["genre"] + "%'";
            SqlCommand command = new SqlCommand(SQL, conn);
            //command.Parameters.AddWithValue("@Genre", Request.QueryString["genre"]);

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

            GetSeriesByGenre(Request.QueryString["genre"], currentPage);

            if (pagedDataSource.IsLastPage)
            {
                Response.Redirect("/Series/Category.aspx?genre=" + Request.QueryString["genre"] + "&page=" + (currentPage));
                return;
            }


            Response.Redirect("/Series/Category.aspx?genre=" + Request.QueryString["genre"] + "&page=" + urlPage);
        }

        protected void PrevPageAction(object sender, EventArgs e)
        {
            int urlPage = currentPage - 1;

            GetSeriesByGenre(Request.QueryString["genre"], currentPage);

            if (pagedDataSource.IsFirstPage)
            {
                Response.Redirect("/Series/Category.aspx?genre=" + Request.QueryString["genre"] + "&page=" + (currentPage));
                return;
            }
            Response.Redirect("/Series/Category.aspx?genre=" + Request.QueryString["genre"] + "&page=" + urlPage);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="PostManagementForm">
        <asp:datalist cssclass="PostDataList" runat="server" id="PostDataList" repeatdirection="Vertical">
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
        </asp:datalist>
    </div>
    <div class="Pagination">
        <asp:button runat="server" id="PrevButton" cssclass="Button" text="Prev" onclick="PrevPageAction" />
        <asp:label runat="server" id="PageLabel" cssclass="PageLabel" text="Page 1"></asp:label>
        <asp:button runat="server" id="Button1" cssclass="Button" text="Next" onclick="NextPageAction" />
    </div>
</asp:Content>
