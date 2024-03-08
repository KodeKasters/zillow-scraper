const buildUrlFromQueryParams = ({ baseUrl, queryParams }) => {
  return `${baseUrl}${encodeURIComponent(JSON.stringify(queryParams))}`;
};
module.exports = buildUrlFromQueryParams;
