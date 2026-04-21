FROM regime-base:latest AS base

USER root
RUN pip install --no-cache-dir matplotlib>=3.7 \
    regime-visualization@git+https://github.com/RegimeDetectionApp/regime-visualization.git@main \
    regime-backtesting@git+https://github.com/RegimeDetectionApp/regime-backtesting.git@main
USER appuser

ENV MPLBACKEND=Agg
COPY --chown=appuser:appuser services/visualization/ /app/services/visualization/
EXPOSE 7005
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD python -c "import httpx; httpx.get('http://localhost:7005/health').raise_for_status()"
CMD ["uvicorn", "services.visualization.app:app", "--host", "0.0.0.0", "--port", "7005"]
