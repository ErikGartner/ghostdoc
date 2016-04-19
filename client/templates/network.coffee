Template.network.onRendered ->

  @autorun =>

    analytics = @data.analytics()
    if not analytics?
      return

    network = analytics.data.network_analytics
    console.log 'Network data:', network


    idMap = {}
    minCent = 1
    maxCent = 0

    nodes = Artifacts.find({project: @data.project}).map (doc, index) ->
      idMap[doc._id] = index
      centrality = network.centrality[doc._id]
      minCent = Math.min minCent, centrality
      maxCent = Math.max maxCent, centrality
      node =
        name: doc.name
        image: doc.image
        centrality: centrality
        community: network.communities[doc._id]
      return node

    console.log 'Mappings:', idMap, nodes

    links = []
    minCount = 1000
    maxCount = 0
    _.each network.pair_occurences, (toObj, from) ->
      _.each toObj, (count, to) ->
        link = {source: idMap[from], target: idMap[to], value: count}
        minCount = Math.min minCount, count
        maxCount = Math.max maxCount, count
        links.push link

    console.log nodes, links
    json = {nodes: nodes, links: links}

    width = 900
    height = 800

    svg = d3.select("#artifactGraph").append("svg")
      .attr("width", width)
      .attr("height", height)

    force = d3.layout.force()
      .gravity(0.05)
      .distance(250)
      .charge((node, index) ->
        console.log node, index
        return -100
      )
      .linkDistance((link, index) ->
        norm = 1 - (link.value - minCount) / (maxCount - minCount)
        res = norm * 300 + 15
        console.log link, index, norm, res
        return res
      )
      .linkStrength(0.9)
      .size([width, height])

    force
      .nodes(json.nodes)
      .links(json.links)
      .start()

    link = svg.selectAll(".link")
      .data(json.links)
      .enter().append("line")
      .attr("class", "link")

    node = svg.selectAll(".node")
      .data(json.nodes)
      .enter().append("g")
      .attr("class", "node")
      .call(force.drag)

    node.append("image")
      .attr("xlink:href", (d) ->
        return d.image)
      .attr("x", (d) ->
        normed = (d.centrality - minCent) / (maxCent - minCent)
        size = 54 * normed + 10
        return size / -2
      )
      .attr("y", (d) ->
        normed = (d.centrality - minCent) / (maxCent - minCent)
        size = 54 * normed + 10
        return size / -2
      )
      .attr("width", (d) ->
        normed = (d.centrality - minCent) / (maxCent - minCent)
        size = 54 * normed + 10
        return size
      )
      .attr("height", (d) ->
        normed = (d.centrality - minCent) / (maxCent - minCent)
        size = 54 * normed + 10
        return size
      )

    node.append("text")
      .attr("x", (d) ->
        normed = (d.centrality - minCent) / (maxCent - minCent)
        size = 54 * normed + 10
        return size / 2
      )
      .attr("y", (d) ->
        normed = (d.centrality - minCent) / (maxCent - minCent)
        size = 54 * normed + 10
        return size / 4
      )
      .style("font-size", (d) ->
        normed = (d.centrality - minCent) / (maxCent - minCent)
        size = 2.5 * normed + 0.5
        return size  + "em")
      .text((d) ->
        return d.name + ' - ' + d.community
      )

    force.on "tick", ->

      # link.attr("x1", (d) ->
      #   return d.source.x
      #   )
      #   .attr("y1", (d) ->
      #     return d.source.y
      #   )
      #   .attr("x2", (d) ->
      #     return d.target.x
      #   )
      #   .attr("y2", (d) ->
      #     return d.target.y
      #   )

      node.attr("transform", (d) ->
        return "translate(" + d.x + "," + d.y + ")"
      )
