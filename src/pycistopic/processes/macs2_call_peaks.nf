nextflow.enable.dsl=2

// binDir = !params.containsKey("test") ? "${workflow.projectDir}/src/template/bin/" : ""

toolParams = params.tools.pycistopic
processParams = params.tools.pycistopic.macs2_call_peaks

process SC__PYCISTOPIC__MACS2_CALL_PEAKS {

    container toolParams.container
    label 'compute_resources__cpu'

    input:
        tuple val(sampleId),
              path(bam),
              path(bam_index),
              val(filetype)

    output:
        tuple val(sampleId),
              path("${sampleId}_peaks.narrowPeak"),
              path("${sampleId}_summits.bed")

    script:
        def sampleParams = params.parseConfig(sampleId, params.global, toolParams)
        """
        macs2 callpeak \
            --treatment ${bam} \
            --name ${sampleId} \
            --outdir . \
            --format BAMPE \
            --gsize ${processParams.gsize} \
            --qvalue ${processParams.qvalue} \
            --nomodel \
            --shift ${processParams.shift} \
            --extsize ${processParams.extsize} \
            --keep-dup ${processParams.keepdup} \
            --call-summits \
            --nolambda
        """
}

