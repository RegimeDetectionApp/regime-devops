FROM regime-base:latest AS base

USER root
RUN pip install --no-cache-dir \
    regime-feature-engine@git+https://github.com/RegimeDetectionApp/regime-feature-engine.git@main
USER appuser

COPY --chown=appuser:appuser services/feature_engine/ /app/services/feature_engine/
EXPOSE 7002
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD python -c "import httpx; httpx.get('http://localhost:7002/health').raise_for_status()"
CMD ["uvicorn", "services.feature_engine.app:app", "--host", "0.0.0.0", "--port", "7002"]
