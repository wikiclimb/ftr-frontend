Map<String, Map<String, String>> linkHeaders = {
  'hasNextPage': {
    'Link': '<https://api.wikiclimb.org/nodes?q=some&page=45>; rel=self, '
        '<https://api.wikiclimb.org/nodes?q=some&page=1>; rel=first, '
        '<https://api.wikiclimb.org/nodes?q=some&page=46>; rel=next, '
        '<https://api.wikiclimb.org/nodes?q=some&page=102>; rel=last'
  }
};
