/* Toledo /search/ script — site/DESIGN.md §12. Vanilla JS, no framework.
 * /search/ ships a <noscript> fallback to /browse/ plus a hidden
 * #search-app; unhidden once the index loads. Paths are relative (page is
 * the fixed one-level /search/index.html) so they resolve under a project
 * subpath or a domain root alike — see PLACEHOLDERS.md. Ranking weights
 * ported from mcp/toledo_mcp/core.py::_score_entry (exact=100, code
 * substr=40, name substr=15, excerpt substr=10).
 */
(function () {
  "use strict";
  var DATA_URL = "../data/search-index.json";
  var RESULT_CAP = 200;

  var app = document.getElementById("search-app");
  if (!app) return;
  var input = document.getElementById("search-input");
  var status = document.getElementById("search-status");
  var tbody = document.getElementById("search-results-body");
  var INDEX = null;

  function esc(s) {
    return String(s == null ? "" : s).replace(/[&<>"']/g, function (c) {
      return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c];
    });
  }

  function siteSlug(code) {
    return code.replace(/\//g, "__").replace(/\./g, "_");
  }

  function statusVariant(status) {
    if (status === "current") return "current";
    if (status === "split" || status === "not_an_equation" || status === "superseded_by") return "bad";
    return "caution";
  }

  function score(row, needle) {
    var n = needle.toLowerCase();
    if (!n) return 0;
    var s = 0;
    var code = row.code.toLowerCase();
    if (code === n) s += 100;
    else if (code.indexOf(n) !== -1) s += 40;
    if ((row.name || "").toLowerCase().indexOf(n) !== -1) s += 15;
    if ((row.excerpt || "").toLowerCase().indexOf(n) !== -1) s += 10;
    return s;
  }

  function codeCompare(a, b) {
    return a.code < b.code ? -1 : a.code > b.code ? 1 : 0;
  }

  function render(query) {
    var q = query.trim();
    if (!q) {
      tbody.innerHTML = "";
      status.textContent = "Type a code, name, or word from a statement.";
      return;
    }
    var hits = [];
    for (var i = 0; i < INDEX.length; i++) {
      var s = score(INDEX[i], q);
      if (s > 0) hits.push({ row: INDEX[i], score: s });
    }
    hits.sort(function (a, b) {
      return b.score - a.score || codeCompare(a.row, b.row);
    });
    var shown = hits.slice(0, RESULT_CAP);
    var rows = shown
      .map(function (h) {
        var r = h.row;
        var href = "../entries/" + siteSlug(r.code) + ".html";
        return (
          "<tr><td class=\"code-cell\"><a href=\"" + esc(href) + "\">" + esc(r.code) + "</a></td>" +
          "<td>" + esc(r.name) + "</td>" +
          "<td><span class=\"badge badge-tier\">" + esc(r.tier) + "</span></td>" +
          "<td>" + esc(r.domain) + "</td>" +
          "<td><span class=\"badge badge-status badge-status--" + statusVariant(r.status) + "\">" + esc(r.status) + "</span></td></tr>"
        );
      })
      .join("");
    tbody.innerHTML = rows;
    if (hits.length === 0) {
      status.textContent = "No matches for “" + q + "”. Try /browse/ instead.";
    } else if (hits.length > RESULT_CAP) {
      status.textContent =
        hits.length + " matches — showing the top " + RESULT_CAP + ". Refine your search for more precise results.";
    } else {
      status.textContent = hits.length + " match" + (hits.length === 1 ? "" : "es") + ".";
    }
  }

  status.textContent = "Loading search index…";
  fetch(DATA_URL)
    .then(function (resp) {
      if (!resp.ok) throw new Error("HTTP " + resp.status);
      return resp.json();
    })
    .then(function (data) {
      INDEX = data;
      app.hidden = false;
      status.textContent = "Type a code, name, or word from a statement.";
      input.addEventListener("input", function () {
        render(input.value);
      });
      if (input.value) render(input.value);
      input.focus();
    })
    .catch(function (err) {
      status.textContent =
        "Search index failed to load (" + err.message + "). Use /browse/ instead.";
      app.hidden = false;
      input.setAttribute("disabled", "disabled");
    });
})();
