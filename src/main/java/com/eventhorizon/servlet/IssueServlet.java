package com.eventhorizon.servlet;

import com.eventhorizon.model.Issue;
import com.eventhorizon.model.IssueReply;
import com.eventhorizon.service.IssueService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class IssueServlet extends HttpServlet {

    private final IssueService issueService = new IssueService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "report";
        }

        HttpSession session = request.getSession(false);

        switch (action) {

            case "report": {
                if (session == null || session.getAttribute("userId") == null) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    return;
                }

                int userId = parseSessionUserId(session);
                List<Issue> myIssues = issueService.getIssuesByUser(userId);
                request.setAttribute("myIssues", myIssues);
                request.getRequestDispatcher("/reportIssue.jsp").forward(request, response);
                return;
            }

            case "myIssues": {
                if (session == null || session.getAttribute("userId") == null) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    return;
                }

                int userId = parseSessionUserId(session);
                List<Issue> myIssues = issueService.getIssuesByUser(userId);
                request.setAttribute("myIssues", myIssues);
                request.getRequestDispatcher("/reportIssue.jsp").forward(request, response);
                return;
            }

            case "adminList": {
                if (!isAdmin(session)) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    return;
                }

                String adminType = getAdminType(session);
                String catFilter = normalizeFilter(request.getParameter("category"));
                String statFilter = normalizeFilter(request.getParameter("status"));

                List<Issue> issueList;
                if ("CORE_ADMIN".equals(adminType)) {
                    issueList = issueService.getIssuesByFilter(null, catFilter, statFilter);
                } else if ("EVENTS_AND_BOOKINGS_ADMIN".equals(adminType)) {
                    issueList = issueService.getIssuesByFilter("EVENTS_ADMIN,BOOKINGS_ADMIN", catFilter, statFilter);
                } else {
                    issueList = issueService.getIssuesByFilter(adminType, catFilter, statFilter);
                }

                request.setAttribute("issueList", issueList);
                request.setAttribute("adminType", adminType);
                request.setAttribute("catFilter", catFilter);
                request.setAttribute("statFilter", statFilter);
                request.setAttribute("openCount", issueService.countByStatus("OPEN", adminType));
                request.setAttribute("progressCount", issueService.countByStatus("IN_PROGRESS", adminType));
                request.setAttribute("resolvedCount", issueService.countByStatus("RESOLVED", adminType));
                request.setAttribute("showingCount", issueList != null ? issueList.size() : 0);

                request.getRequestDispatcher("/admin/issues.jsp").forward(request, response);
                return;
            }

            case "adminDetail": {
                if (!isAdmin(session)) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    return;
                }

                String idParam = request.getParameter("id");
                if (idParam == null || idParam.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/IssueServlet?action=adminList");
                    return;
                }

                int issueId = Integer.parseInt(idParam.trim());
                Issue issue = issueService.getIssueById(issueId);

                if (issue == null) {
                    response.sendRedirect(request.getContextPath() + "/IssueServlet?action=adminList");
                    return;
                }

                request.setAttribute("issue", issue);
                request.getRequestDispatcher("/admin/issueDetails.jsp").forward(request, response);
                return;
            }

            default:
                response.sendRedirect(request.getContextPath() + "/IssueServlet?action=report");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);

        switch (action != null ? action : "") {

            case "submit": {
                if (session == null || session.getAttribute("userId") == null) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    return;
                }

                int userId = parseSessionUserId(session);

                String category = request.getParameter("category");
                String subject = request.getParameter("subject");
                String desc = request.getParameter("description");
                String priority = request.getParameter("priority");
                String email = request.getParameter("customerEmail");
                String phone = request.getParameter("customerPhone");

                Integer bookingId = parseOptionalInteger(request.getParameter("bookingId"));
                Integer ticketId = parseOptionalInteger(request.getParameter("ticketId"));

                String assignedType = IssueService.resolveAdminType(category);

                Issue issue = new Issue(
                        userId,
                        category,
                        subject,
                        desc,
                        priority,
                        assignedType,
                        email,
                        phone,
                        bookingId,
                        ticketId
                );

                boolean ok = issueService.submitIssue(issue);

                if (ok) {
                    session.setAttribute("successMsg",
                            "Your issue has been submitted successfully. Issue ID: #" + issue.getIssueId());
                } else {
                    session.setAttribute("errorMsg",
                            "Failed to submit issue. Please try again.");
                }

                response.sendRedirect(request.getContextPath() + "/IssueServlet?action=report");
                return;
            }

            case "reply": {
                if (!isAdmin(session)) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    return;
                }

                int issueId = Integer.parseInt(request.getParameter("issueId"));
                String message = request.getParameter("replyMessage");
                String newStatus = request.getParameter("newStatus");
                int adminId = parseSessionUserId(session);

                if (message != null && !message.trim().isEmpty()) {
                    IssueReply reply = new IssueReply(issueId, adminId, message.trim());
                    issueService.addReply(reply);
                }

                if (newStatus != null && !newStatus.trim().isEmpty()) {
                    issueService.updateStatus(issueId, newStatus);
                }

                response.sendRedirect(request.getContextPath()
                        + "/IssueServlet?action=adminDetail&id=" + issueId);
                return;
            }

            case "updateStatus": {
                if (!isAdmin(session)) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    return;
                }

                int issueId = Integer.parseInt(request.getParameter("issueId"));
                String status = request.getParameter("status");

                if (status != null && !status.trim().isEmpty()) {
                    issueService.updateStatus(issueId, status);
                }

                response.sendRedirect(request.getContextPath()
                        + "/IssueServlet?action=adminDetail&id=" + issueId);
                return;
            }

            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        Object roleObj = session.getAttribute("role");
        return roleObj != null && "ADMIN".equalsIgnoreCase(String.valueOf(roleObj));
    }

    private String getAdminType(HttpSession session) {
        if (session == null) return "CORE_ADMIN";

        Object permissionObj = session.getAttribute("adminPermission");
        String permission = permissionObj != null ? String.valueOf(permissionObj).toUpperCase() : "";

        if (permission.contains("FULL") || permission.contains("CORE")) {
            return "CORE_ADMIN";
        }
        if (permission.contains("EVENT") && permission.contains("BOOKING")) {
            return "EVENTS_AND_BOOKINGS_ADMIN";
        }
        if (permission.contains("EVENT")) {
            return "EVENTS_ADMIN";
        }
        if (permission.contains("BOOKING")) {
            return "BOOKINGS_ADMIN";
        }
        return "CORE_ADMIN";
    }

    private int parseSessionUserId(HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            throw new IllegalArgumentException("Session userId is missing.");
        }
        return parseFlexibleId(String.valueOf(userIdObj));
    }

    private Integer parseOptionalInteger(String value) {
        if (value == null || value.trim().isEmpty()) return null;
        return Integer.parseInt(value.trim());
    }

    private int parseFlexibleId(String rawValue) {
        if (rawValue == null) throw new IllegalArgumentException("ID value is null.");

        String value = rawValue.trim();
        if (value.isEmpty()) throw new IllegalArgumentException("ID value is empty.");

        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException ignored) {
        }

        String numericPart = value.replaceAll("\\D+", "");
        if (numericPart.isEmpty()) {
            throw new IllegalArgumentException("Invalid ID format: " + value);
        }
        return Integer.parseInt(numericPart);
    }

    private String normalizeFilter(String value) {
        if (value == null) return null;
        value = value.trim();
        if (value.isEmpty()) return null;
        if ("All Categories".equalsIgnoreCase(value) || "All Statuses".equalsIgnoreCase(value)) {
            return null;
        }
        return value;
    }
}