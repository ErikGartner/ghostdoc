Template.network.onRendered ->

  @autorun =>
    artifacts = Artifacts.find project: @data.projectId

    idMap = {}
    nodes = artifacts.map (doc, index) ->
      idMap[doc._id] = index
      return {name: doc.name, image: doc.image}

    links = []
    minCount = 0
    maxCount = 0
    artifacts.forEach (doc) ->
      networkData = Ritter.getData doc._id, 'network'

      _.map networkData.data, (count, id) ->
        source = idMap[doc._id]
        target = idMap[id]
        if source != target# and count > 0
          link = {source: idMap[doc._id], target: idMap[id], value: count }
          minCount = Math.min(minCount, count)
          maxCount = Math.max(maxCount, count)
          links.push link

    console.log nodes, links
    json = {nodes: nodes, links: links}

    width = 900
    height = 800

    svg = d3.select("#artifactGraph").append("svg")
      .attr("width", width)
      .attr("height", height);

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
      .size([width, height]);

    force
      .nodes(json.nodes)
      .links(json.links)
      .start()

    link = svg.selectAll(".link")
      .data(json.links)
      .enter().append("line")
      .attr("class", "link");

    node = svg.selectAll(".node")
      .data(json.nodes)
      .enter().append("g")
      .attr("class", "node")
      .call(force.drag);

    node.append("image")
      .attr("xlink:href", (d) ->
        return d.image)
      .attr("x", -16)
      .attr("y", -16)
      .attr("width", 32)
      .attr("height", 32);

    node.append("text")
      .attr("dx", 12)
      .attr("dy", ".35em")
      .text((d) ->
        return d.name
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
